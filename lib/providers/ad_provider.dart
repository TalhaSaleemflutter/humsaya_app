import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:humsaya_app/database/hive/ad_hive.dart';
import 'package:humsaya_app/models/ad_product_model.dart';
import 'package:humsaya_app/models/category_model.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AdProvider with ChangeNotifier {
  List<AdModel> _products = [];
  List<AdModel> get products => _products;

  List<AdModel> _ads = [];

  List<AdModel> _myAds = [];
  List<AdModel> get myAds => _myAds;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;
  int _currentPage = 0;
  final int _pageSize = 12;

  List<AdModel> _paginatedProducts = [];
  List<AdModel> get paginatedProducts => _paginatedProducts;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  AdModel _currentAds = AdModel(
    uid: '',
    addId: '',
    title: '',
    description: '',
    price: 0.0,
    condition: '',
    location: '',
    listOfImages: [],
    brandName: '',
    createdAt: DateTime.now(),
    isActive: false,
    categoryId: '',
    servicePaymentType: '',
    websiteUrl: '',
    discountPrice: 0.0,
  );
  AdModel get currentAds => _currentAds;

  void updateCurrentAdField(String field, dynamic value) {
    if (_currentAds != null) {
      _currentAds = _currentAds.copyWith(
        uid: field == 'uid' ? value as String : _currentAds.uid,
        addId: field == 'addId' ? value as String : _currentAds.addId,
        title: field == 'title' ? value as String : _currentAds.title,
        description:
            field == 'description' ? value as String : _currentAds.description,
        price: field == 'price' ? value as double : _currentAds.price,
        condition:
            field == 'condition' ? value as String : _currentAds.condition,
        location: field == 'location' ? value as String : _currentAds.location,
        listOfImages:
            field == 'listOfImages'
                ? value as List<String>
                : _currentAds.listOfImages,
        brandName:
            field == 'brandName' ? value as String : _currentAds.brandName,
        categoryId:
            field == 'categoryId' ? value as String : _currentAds.categoryId,
        servicePaymentType:
            field == 'servicePaymentType'
                ? value as String
                : _currentAds.servicePaymentType,
        websiteUrl:
            field == 'websiteUrl' ? value as String : _currentAds.websiteUrl,
        discountPrice:
            field == 'discountPrice'
                ? value as double
                : _currentAds.discountPrice,
        isSold: field == 'isSold' ? value as bool : _currentAds.isSold,
      );

      notifyListeners();
    } else {
      throw StateError('No current ad is set');
    }
  }

  // AdModel getAdById(String id) {
  //   return _products.firstWhere((ad) => ad.addId == id);
  // }

  AdModel? getAdById(String adId) {
    try {
      return _ads.firstWhere((ad) => ad.addId == adId);
    } catch (e) {
      return null; // Return null if ad not found
    }
  }

  CategoryModel getCategoryById(String id) {
    return _categories.firstWhere((ad) => ad.categoryId == id);
  }

  Future<void> createAd(String uId, AdModel product) async {
    product.uid = uId;
    try {
      List<String> imageUrls = [];
      for (String imagePath in product.listOfImages) {
        File imageFile = File(imagePath);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef = FirebaseStorage.instance.ref().child(
          'product_images/$uId/$fileName.jpg',
        );
        await storageRef.putFile(imageFile);
        String downloadUrl = await storageRef.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
      final updatedProduct = product.copyWith(listOfImages: imageUrls);
      final docRef = await FirebaseFirestore.instance
          .collection('products')
          .add(updatedProduct.toMap());
      print('Product data to save: ${updatedProduct.toMap()}');
      final finalProduct = updatedProduct.copyWith(addId: docRef.id);
      await AdHive().saveAd(finalProduct);
      print('Data stored in Firestore and locally.');
    } catch (e) {
      print('Error syncing product to Firestore: $e');
    }
  }

  void clearCurrentAd(bool isNotify) {
    _currentAds = AdModel(
      uid: '',
      addId: '',
      title: '',
      description: '',
      price: 0.0,
      condition: '',
      location: '',
      listOfImages: [],
      brandName: '',
      createdAt: DateTime.now(),
      isActive: false,
      categoryId: '',
      servicePaymentType: '',
      websiteUrl: '',
      discountPrice: 0.0,
    );
    if (isNotify) {
      notifyListeners();
    }
  }

  Future<void> getMyAds(BuildContext context, String userId) async {
    try {
      _myAds.clear();
      setLoading(true);
      print('Fetching my ads from Firestore for user: $userId');
      final querySnapshot =
          await FirebaseFirestore.instance
              .collectionGroup('products')
              .where('uid', isEqualTo: userId)
              .get();
      _myAds =
          querySnapshot.docs.map((doc) {
            final productData = doc.data();
            return AdModel.fromMap({...(productData ?? {}), 'addId': doc.id});
          }).toList();

      if (_myAds.isNotEmpty) {
        print('Found ${_myAds.length} ads for user $userId');

        for (var ad in _myAds) {
          await AdHive().saveAd(ad);
        }
        notifyListeners();
      } else {
        print('No ads found for user $userId');
        final hiveProducts = await AdHive().loadAllAds(userId);
        _myAds = hiveProducts.where((ad) => ad.uid == userId).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching my ads: $e');
      rethrow;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> markAdAsSold(String adId, BuildContext context) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('products')
          .doc(adId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception('Ad with ID $adId not found in Firestore');
      }
      AdModel ad = AdModel.fromMap(docSnapshot.data()!);
      final updatedAd = ad.copyWith(isSold: true);

      await docRef.update({'isSold': true});
      await AdHive().saveAd(updatedAd);

      print('Ad marked as sold successfully.');
    } catch (e) {
      print('Error marking ad as sold: $e');
    }
  }

  Future<void> loadMyAdsFromHive(String userId) async {
    try {
      setLoading(true);
      final hiveProducts = await AdHive().loadAllAds(userId);
      _myAds = hiveProducts.where((ad) => ad.uid == userId).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading ads from Hive: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> resetPagination() async {
    _currentPage = 0;
    _hasMore = true;
    _paginatedProducts.clear();
    notifyListeners();
  }

  Future<void> fetchAndSetAds(BuildContext context, String userId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      if (_currentPage == 0) {
        _products.clear();
        _paginatedProducts.clear();
      }
      setLoading(true);
      final userNeighborLocation =
          authProvider.currentUser.location?.neighborLocation;
      if (userNeighborLocation == null || userNeighborLocation.isEmpty) {
        print('User neighbor location is null or empty. Skipping ad fetch.');
        setLoading(false);
        return;
      }
      print('Fetching all unsold ads from Firestore with location filter');
      final querySnapshot =
          await FirebaseFirestore.instance
              .collectionGroup('products')
              .where('location', isEqualTo: userNeighborLocation)
              .where('isSold', isEqualTo: false)
              .get();
      _products =
          querySnapshot.docs.map((doc) {
            final productData = doc.data();
            return AdModel.fromMap({
              ...productData,
              'addId': doc.id,
              'isSold': productData['isSold'] ?? false,
            });
          }).toList();
      _products = _products.where((ad) => ad.isSold == false).toList();
      if (_products.isNotEmpty) {
        for (var product in _products) {
          if (!product.isSold) {
            await AdHive().saveAd(product);
          }
        }
        loadMoreAds();
      } else {
        print(
          'No matching unsold ads found for location: $userNeighborLocation',
        );

        final hiveProducts = await AdHive().loadAllAds(userId);
        if (hiveProducts.isNotEmpty) {
          print('Falling back to Hive cache');
          _products =
              hiveProducts
                  .where(
                    (ad) => ad.location == userNeighborLocation && !ad.isSold,
                  )
                  .toList();
          loadMoreAds();
        }
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreAds() async {
    if (_isLoadingMore || !_hasMore || _products.isEmpty) return;

    _isLoadingMore = true;
    notifyListeners();

    final startIndex = _currentPage * _pageSize;

    if (startIndex >= _products.length) {
      _hasMore = false;
      _isLoadingMore = false;
      notifyListeners();
      return;
    }

    final endIndex = startIndex + _pageSize;
    final newAds = _products.sublist(
      startIndex,
      endIndex > _products.length ? _products.length : endIndex,
    );

    _paginatedProducts.addAll(newAds);
    _currentPage++;
    _hasMore = endIndex < _products.length;

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> deleteAd(AdModel ad, BuildContext context) async {
    try {
      setLoading(true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (ad.addId != null && ad.addId!.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(ad.addId)
            .delete();
        print('Deleted ad ${ad.addId} from Firestore');
      }

      for (String imageUrl in ad.listOfImages) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(imageUrl);
          await ref.delete();
          print('Deleted image $imageUrl from Storage');
        } catch (e) {
          print('Error deleting image $imageUrl: $e');
        }
      }
      await AdHive().deleteAd(ad.addId!);
      print('Deleted ad ${ad.addId} from Hive');
      _myAds.removeWhere((a) => a.addId == ad.addId);
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ad deleted successfully')));
      await getMyAds(context, authProvider.currentUser.uid);
    } catch (e) {
      print('Error deleting ad: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete ad: ${e.toString()}')),
      );
    } finally {
      setLoading(false);
    }
  }

  String calculateDateDifference(String? createdAt) {
    if (createdAt == null) return 'N/A';
    try {
      DateTime createdDate = DateTime.parse(createdAt);
      DateTime today = DateTime.now();
      Duration difference = today.difference(createdDate);
      if (difference.inDays > 365) {
        int years = (difference.inDays / 365).floor();
        return '$years year${years > 1 ? 's' : ''} ago';
      } else if (difference.inDays > 30) {
        int months = (difference.inDays / 30).floor();
        return '$months month${months > 1 ? 's' : ''} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Invalid date';
    }
  }
}

 // Future<void> fetchAndSetAds(BuildContext context, String userId) async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   try {
  //     if (_currentPage == 0) {
  //       _products.clear();
  //       _paginatedProducts.clear();
  //     }
  //     setLoading(true);
  //     final userNeighborLocation =
  //         authProvider.currentUser.location?.neighborLocation;
  //     if (userNeighborLocation == null || userNeighborLocation.isEmpty) {
  //       print('User neighbor location is null or empty. Skipping ad fetch.');
  //       setLoading(false);
  //       return;
  //     }
  //     print('Fetching all ads from Firestore with location filter');
  //     final querySnapshot =
  //         await FirebaseFirestore.instance.collectionGroup('products').get();
  //     _products =
  //         querySnapshot.docs
  //             .where((doc) => doc['location'] == userNeighborLocation)
  //             .map((doc) {
  //               final productData = doc.data();
  //               return AdModel.fromMap({
  //                 ...(productData ?? {}),
  //                 'addId': doc.id,
  //               });
  //             })
  //             .toList();
  //     if (_products.isNotEmpty) {
  //       for (var product in _products) {
  //         await AdHive().saveAd(product);
  //       }
  //       loadMoreAds();
  //     } else {
  //       print('No matching ads found for location: $userNeighborLocation');
  //       final hiveProducts = await AdHive().loadAllAds(userId);
  //       if (hiveProducts.isNotEmpty) {
  //         print('Falling back to Hive cache');
  //         _products =
  //             hiveProducts
  //                 .where((ad) => ad.location == userNeighborLocation)
  //                 .toList();
  //         loadMoreAds();
  //       }
  //     }
  //   } catch (e) {
  //     print('Error fetching products: $e');
  //     rethrow;
  //   } finally {
  //     setLoading(false);
  //   }
  // }


    // Future<void> fetchAndSetAds(
  //   BuildContext context,
  //   String userId, {
  //   bool loadMore = false,
  // }) async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   try {
  //     if (!loadMore) {
  //       // If it's not a load more request, reset everything
  //       _products.clear();
  //       _lastDocument = null;
  //       _hasMore = true;
  //     }
  //     if (!_hasMore) return;
  //     setLoading(true);
  //     final userNeighborLocation =
  //         authProvider.currentUser.location?.neighborLocation;
  //     if (userNeighborLocation == null || userNeighborLocation.isEmpty) {
  //       print('User neighbor location is null or empty. Skipping ad fetch.');
  //       setLoading(false);
  //       return;
  //     }

  //     print('Fetching ads from Firestore with location filter');
  //     Query query = FirebaseFirestore.instance
  //         .collection('products')
  //         .where('location', isEqualTo: userNeighborLocation)
  //         .limit(_pageSize);

  //     // If we're loading more, start after the last document
  //     if (loadMore && _lastDocument != null) {
  //       query = query.startAfterDocument(_lastDocument!);
  //     }
  //     final querySnapshot = await query.get();

  //     if (querySnapshot.docs.isEmpty) {
  //       _hasMore = false;
  //       if (!loadMore) {
  //         // No ads found in Firestore, try Hive
  //         print('No matching ads found for location: $userNeighborLocation');
  //         final hiveProducts = await AdHive().loadAllAds(userId);
  //         if (hiveProducts.isNotEmpty) {
  //           print('Falling back to Hive cache');
  //           _products =
  //               hiveProducts
  //                   .where((ad) => ad.location == userNeighborLocation)
  //                   .toList();
  //         }
  //       }
  //     } else {
  //       // Update last document for pagination
  //       _lastDocument = querySnapshot.docs.last;
  //       final newProducts =
  //           querySnapshot.docs.map((doc) {
  //             final productData = doc.data();
  //             final Map<String, dynamic> dataMap =
  //                 productData is Map<String, dynamic>
  //                     ? productData
  //                     : {}; // Fallback to empty map if not the right type
  //             return AdModel.fromMap({...dataMap, 'addId': doc.id});
  //           }).toList();

  //       if (loadMore) {
  //         _products.addAll(newProducts);
  //       } else {
  //         _products = newProducts;
  //       }
  //       for (var product in newProducts) {
  //         await AdHive().saveAd(product);
  //       }
  //       if (newProducts.length < _pageSize) {
  //         _hasMore = false;
  //       }
  //     }

  //     notifyListeners();
  //   } catch (e) {
  //     print('Error fetching products: $e');
  //     rethrow;
  //   } finally {
  //     setLoading(false);
  //   }
  // }

  // Add this new function to load more ads

  // Future<void> loadMoreAds(BuildContext context, String userId) async {
  //   await fetchAndSetAds(context, userId, loadMore: true);
  // }


