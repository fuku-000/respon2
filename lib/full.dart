import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class FullPage extends StatefulWidget {
  @override
  _FullPageState createState() => _FullPageState();
}

class _FullPageState extends State<FullPage> {
  final List<String> names = ['John Doe', 'Jane Smith', 'Alice Johnson', 'Bob Brown'];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _memos = {};

  void _addName() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        names.add(_nameController.text);
        _nameController.clear();
      });
    }
  }

  void _addMemo() {
    if (_selectedDay != null && _memoController.text.isNotEmpty) {
      setState(() {
        if (_memos[_selectedDay!] != null) {
          _memos[_selectedDay!]!.add(_memoController.text);
        } else {
          _memos[_selectedDay!] = [_memoController.text];
        }
        _memoController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCalendar(),
            const SizedBox(height: 16.0),
            _buildNameInput(),
            const SizedBox(height: 16.0),
            if (_selectedDay != null) _buildMemoInput(),
            const SizedBox(height: 16.0),
            _buildNameList(),
            if (_selectedDay != null) _buildMemoList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(12.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; 
          });
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _buildNameInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Enter name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: _addName,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16.0),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildMemoInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _memoController,
            decoration: const InputDecoration(
              labelText: 'Enter memo for the day',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: _addMemo,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16.0),
          ),
          child: const Icon(Icons.add_comment, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildNameList() {
    return Expanded(
      child: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(names[index]),
              tileColor: Colors.blue[50],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMemoList() {
    final memos = _memos[_selectedDay!] ?? [];
    return Expanded(
      child: ListView.builder(
        itemCount: memos.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              leading: const Icon(Icons.note),
              title: Text(memos[index]),
              tileColor: Colors.yellow[50],
            ),
          );
        },
      ),
    );
  }
}
