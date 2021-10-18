import 'package:flutter/material.dart';

enum _SectionListViewItemType {
  sectionHeader,
  sectionSeparator,
  item,
  itemSeparator,    
}

class _SectionListViewItem {  
  final _SectionListViewItemType type;
  final int sectionIndex;
  final int? index;

  const _SectionListViewItem(this.type, this.sectionIndex, { this.index });  
}

class SectionListView extends StatelessWidget {
  final List<int> itemCounts;
  final EdgeInsets? padding;

  final Widget Function(BuildContext context, int sectionIndex)? sectionHeaderBuilder;
  final Widget Function(BuildContext context, int sectionIndex, int index)? sectionItemBuilder;
  final Widget Function(BuildContext context, int sectionIndex)? sectionSeparatorBuilder;
  final Widget Function(BuildContext context, int sectionIndex, int index)? sectionItemSeparatorBuilder;
      
  const SectionListView({
    Key? key,    
    this.padding,
    required this.itemCounts,
    required this.sectionItemBuilder,    
    this.sectionHeaderBuilder,
    this.sectionSeparatorBuilder,
    this.sectionItemSeparatorBuilder
  }) :   
  super(key: key);

  @override
  Widget build(BuildContext context) {    
    List<_SectionListViewItem> _items = [];
    
    for (var sectionIndex = 0; sectionIndex < itemCounts.length; sectionIndex++) {      
      if (sectionHeaderBuilder != null) _items.add(_SectionListViewItem(_SectionListViewItemType.sectionHeader, sectionIndex));

      for (var itemIndex = 0; itemIndex < itemCounts[sectionIndex]; itemIndex++) {
        _items.add(_SectionListViewItem(_SectionListViewItemType.item, sectionIndex, index: itemIndex));
        if (sectionItemSeparatorBuilder != null && itemIndex < itemCounts[sectionIndex]-1) {
          _items.add(_SectionListViewItem(_SectionListViewItemType.itemSeparator, sectionIndex, index: itemIndex));
        }
      }

      if (sectionSeparatorBuilder != null && sectionIndex < itemCounts.length-1) {
        _items.add(_SectionListViewItem(_SectionListViewItemType.sectionSeparator, sectionIndex));
      }
    }

    return ListView.builder(
      padding: padding,
      itemBuilder: (context, index) {
        final item = _items[index];
        Widget? itemWidget;

        if (item.type == _SectionListViewItemType.sectionHeader && sectionHeaderBuilder != null) {
          itemWidget = sectionHeaderBuilder!(context, item.sectionIndex);
        } else if (item.type == _SectionListViewItemType.sectionSeparator && sectionSeparatorBuilder != null) {        
          itemWidget = sectionSeparatorBuilder!(context, item.sectionIndex);
        } else if (item.type == _SectionListViewItemType.item && sectionItemBuilder != null) {
          itemWidget = sectionItemBuilder!(context, item.sectionIndex, item.index!);
        } else if (sectionItemSeparatorBuilder != null) {
          itemWidget = sectionItemSeparatorBuilder!(context, item.sectionIndex, item.index!);
        }

        return itemWidget ?? Container();
      },

      itemCount: _items.length,
    );
  }
}