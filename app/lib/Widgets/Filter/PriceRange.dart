import 'package:flutter/material.dart';

class PriceRange extends StatefulWidget {
  final int min, max;
  final Function(RangeValues) onChange;
  const PriceRange(
      {Key key, this.min, this.max, Function(RangeValues) this.onChange})
      : super(key: key);

  @override
  _PriceRangeState createState() => _PriceRangeState();
}

class _PriceRangeState extends State<PriceRange> {
  double _min = 0, _max = 100;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Text((_min * (widget.max / 100)).round().toString()),
          width: 100,
        ),
        Expanded(
            child: RangeSlider(
          min: 0,
          max: 100,
          values: RangeValues(_min, _max),
          onChanged: (v) {
            setState(() {
              _min = v.start;
              _max = v.end;
              widget.onChange(RangeValues(
                  (v.start * widget.min) / 100, (v.end * widget.max) / 100));
            });
          },
        )),
        Container(
          child: Text((_max * (widget.max / 100)).round().toString()),
          width: 100,
        )
      ],
    );
  }
}
