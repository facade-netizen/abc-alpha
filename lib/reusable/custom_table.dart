import 'package:flutter/material.dart';
import '../../../reusable/colors.dart';

/// GENERIC HYBRID TABLE
class CustomTable<T> extends StatelessWidget {
  final List<T> data;
  final List<TableColumn<T>> columns;
  final Widget? child;
  final double? tableTopPadding;
  final double? rowVerticalPadding;
  const CustomTable({
    super.key,
    this.child,
    required this.data,
    required this.columns,
    this.tableTopPadding,
    this.rowVerticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30, top: tableTopPadding ?? 30),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            if (child != null) SizedBox(child: child),

            /// HEADER
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE4E4E4),
                border: Border(
                  top: BorderSide(color: borderColor),
                  bottom: BorderSide(color: borderColor),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: rowVerticalPadding ?? 4),
                child: Row(
                  children: columns.map((col) {
                    return _buildColumnWrapper(
                      col: col,
                      child: SelectableText(
                        col.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: headerTextColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            /// BODY
            ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final row = data[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: rowVerticalPadding ?? 4),
                  decoration: BoxDecoration(
                    color: white,
                    border: Border(
                      bottom: BorderSide(
                        color: index == data.length - 1 ? borderColor : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    children: columns.map((col) {
                      final text = col.value?.call(row) ?? '';
                      final color = col.color != null ? col.color!(row) : Colors.black;

                      if (col.customCell != null) {
                        return _buildColumnWrapper(
                          col: col,
                          child: col.customCell!(row),
                        );
                      }

                      return _buildColumnWrapper(
                        col: col,
                        child: SelectableText(
                          text,
                          cursorWidth: 1,
                          textDirection: col.alignRight ? TextDirection.rtl : TextDirection.ltr,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: col.fontWeight,
                            color: color,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// CELL WRAPPER
  Widget _buildColumnWrapper({
    required TableColumn col,
    required Widget child,
  }) {
    /// FIXED WIDTH
    if (col.width != null) {
      return SizedBox(
        width: col.width,
        child: _alignCell(col, child),
      );
    }

    /// FLEXIBLE WIDTH
    return Flexible(
      flex: (col.flex * 100).toInt(),
      child: _alignCell(col, child),
    );
  }

  /// ALIGNMENT + PADDING
  Widget _alignCell(TableColumn col, Widget child) {
    return Container(
      alignment: col.alignCenter
          ? Alignment.center
          : col.alignRight
              ? Alignment.centerRight
              : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: child,
    );
  }
}

/// COLUMN MODEL
class TableColumn<T> {
  final String label;
  final double? width;
  final double flex;

  final bool alignRight;
  final bool alignCenter;
  final FontWeight fontWeight;

  final Color Function(T row)? color;
  final String Function(T row)? value;
  final Widget Function(T row)? customCell;

  const TableColumn({
    required this.label,
    this.width,
    this.flex = 1,
    this.value,
    this.customCell,
    this.alignCenter = false,
    this.alignRight = false,
    this.color,
    this.fontWeight = FontWeight.normal,
  });
}
