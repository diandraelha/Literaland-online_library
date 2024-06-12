import 'package:flutter/material.dart';
import 'package:literaland/Controller/ApiService.dart';
import 'package:literaland/Model/book.dart';
import 'package:literaland/Model/borrowed-book.dart';

class AdminBorrowRequestsScreen extends StatefulWidget {
  @override
  _AdminBorrowRequestsScreenState createState() => _AdminBorrowRequestsScreenState();
}

class _AdminBorrowRequestsScreenState extends State<AdminBorrowRequestsScreen> {
  late Future<List<BorrowedBook>> _borrowRequestsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _borrowRequestsFuture = _apiService.fetchAllBorrowRequests();
  }

  Future<void> _approveRequest(BorrowedBook book) async {
    try {
      final response = await _apiService.updateBorrowStatus(book.id, 'borrowed');

      print('Raw response: $response'); // Add this line to log the raw response

      if (response['status'] == 'success') {
        setState(() {
          _borrowRequestsFuture = _apiService.fetchAllBorrowRequests();
        });
      } else {
        throw Exception(response['message'] ?? 'Failed to approve request');
      }
    } catch (e) {
      print('Error approving request: $e');
    }
  }

  Future<void> _rejectRequest(BorrowedBook book) async {
    try {
      final response = await _apiService.updateBorrowStatus(book.id, 'rejected');

      if (response['status'] == 'success') {
        setState(() {
          _borrowRequestsFuture = _apiService.fetchAllBorrowRequests();
        });
      } else {
        throw Exception(response['message'] ?? 'Failed to reject request');
      }
    } catch (e) {
      print('Error rejecting request: $e');
    }
  }

  Future<Book?> _fetchBookDetails(int bookId) async {
    try {
      return await _apiService.fetchBookById(bookId);
    } catch (e) {
      print('Error fetching book details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrow Requests'),
      ),
      body: FutureBuilder<List<BorrowedBook>>(
        future: _borrowRequestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No borrow requests found'));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return FutureBuilder<Book?>(
                future: _fetchBookDetails(request.bookId),
                builder: (context, bookSnapshot) {
                  if (bookSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (bookSnapshot.hasError) {
                    return Center(child: Text('Error fetching book details'));
                  } else if (!bookSnapshot.hasData) {
                    return Center(child: Text('Book details not found'));
                  }

                  final book = bookSnapshot.data!;
                  return _buildRequestCard(request, book);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(BorrowedBook request, Book book) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black38,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Author: ${book.author}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        'Borrowed: ${request.borrowedDate.toLocal()}'.split(' ')[0],
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () async {
                          await _approveRequest(request);
                        },
                        child: Text('Approve'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {
                          await _rejectRequest(request);
                        },
                        child: Text('Reject'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}