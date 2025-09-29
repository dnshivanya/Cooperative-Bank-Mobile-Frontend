import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../constants/app_colors.dart';

class AppDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool isPaginated;
  final int? rowsPerPage;
  final bool showCheckboxColumn;
  final bool showFirstLastRows;
  final String? emptyText;
  final Widget? emptyWidget;
  final double? minWidth;
  final double? maxWidth;
  final double? height;
  final Color? headingRowColor;
  final Color? dataRowColor;
  final BorderRadius? borderRadius;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isPaginated = false,
    this.rowsPerPage,
    this.showCheckboxColumn = false,
    this.showFirstLastRows = true,
    this.emptyText,
    this.emptyWidget,
    this.minWidth,
    this.maxWidth,
    this.height,
    this.headingRowColor,
    this.dataRowColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (rows.isEmpty) {
      return Container(
        height: height ?? 200,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        child: Center(
          child: emptyWidget ?? 
            Text(
              emptyText ?? 'No data available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground,
              ),
            ),
        ),
      );
    }

    return Container(
      height: height,
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0,
        maxWidth: maxWidth ?? double.infinity,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.card,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: minWidth ?? 0,
        headingRowColor: MaterialStateProperty.all(
          headingRowColor ?? (isDark ? AppColors.darkMuted : AppColors.muted),
        ),
        dataRowColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return isDark ? AppColors.darkAccent : AppColors.accent;
          }
          return dataRowColor ?? Colors.transparent;
        }),
        columns: columns,
        rows: rows,
        showCheckboxColumn: showCheckboxColumn,
        empty: emptyWidget ?? 
          Center(
            child: Text(
              emptyText ?? 'No data available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground,
              ),
            ),
          ),
      ),
    );
  }
}

