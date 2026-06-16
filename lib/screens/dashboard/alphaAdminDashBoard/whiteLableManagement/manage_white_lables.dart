import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/fetchBlocs/fetch_all_wl_bloc.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/no_data.dart';
import 'white_lables_table.dart';

class ManageWhiteLable extends StatefulWidget {
  const ManageWhiteLable({super.key});

  @override
  State<ManageWhiteLable> createState() => _ManageWhiteLableState();
}

class _ManageWhiteLableState extends State<ManageWhiteLable> {
  @override
  void initState() {
    context.read<FetchAllWLBloc>().add(FetchAllWL());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchAllWLBloc, FetchAllWLState>(
      builder: (context, wls) {
        return wls is FetchAllWLProgress
            ? LoaderContainerWithMessage()
            : wls is FetchAllWLSuccess
            ? WhiteLablesTable(whiteLables: wls.wlData)
            : NoData(msg: "Unable to fetch admin data");
      },
    );
  }
}
