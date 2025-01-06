import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/member_provider.dart';
import '../models/member.dart';

class MemberListScreen extends StatelessWidget {
  static const routeName = '/member-list';

  const MemberListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anggota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddMemberDialog(context),
          ),
        ],
      ),
      body: Consumer<MemberProvider>(
        builder: (ctx, memberProvider, _) {
          final members = memberProvider.members;
          if (members.isEmpty) {
            return const Center(
              child: Text('Belum ada anggota perpustakaan'),
            );
          }
          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (ctx, i) => MemberListItem(member: members[i]),
          );
        },
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const AddMemberDialog(),
    );
  }
}

class MemberListItem extends StatelessWidget {
  final Member member;

  const MemberListItem({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListTile(
        title: Text(member.name),
        subtitle: Text(member.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditMemberDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AddMemberDialog(member: member),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Anggota'),
        content: Text('Apakah Anda yakin ingin menghapus ${member.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<MemberProvider>(context, listen: false)
                  .deleteMember(member.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class AddMemberDialog extends StatefulWidget {
  final Member? member;

  const AddMemberDialog({super.key, this.member});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _phone;
  late String _address;

  @override
  void initState() {
    super.initState();
    _name = widget.member?.name ?? '';
    _email = widget.member?.email ?? '';
    _phone = widget.member?.phoneNumber ?? '';
    _address = widget.member?.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.member == null ? 'Tambah Anggota' : 'Edit Anggota'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Nama harus diisi' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Email harus diisi' : null,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Nomor telepon harus diisi' : null,
                onSaved: (value) => _phone = value!,
              ),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Alamat harus diisi' : null,
                onSaved: (value) => _address = value!,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: _saveMember,
          child: Text(widget.member == null ? 'Tambah' : 'Simpan'),
        ),
      ],
    );
  }

  void _saveMember() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final memberProvider = Provider.of<MemberProvider>(context, listen: false);

    final member = Member(
      id: widget.member?.id ?? DateTime.now().toString(),
      name: _name,
      email: _email,
      phoneNumber: _phone,
      address: _address,
      memberSince: widget.member?.memberSince ?? DateTime.now(),
    );

    if (widget.member == null) {
      memberProvider.addMember(member);
    } else {
      memberProvider.updateMember(member);
    }

    Navigator.of(context).pop();
  }
}
