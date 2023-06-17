(* ::Package:: *)

title = Style[
	"O\[PartialD]E Test\nProblems",
	FontSize -> Scaled[0.18],
	FontFamily -> "Times",
	FontWeight -> Bold,
	LineSpacing -> {3.25, 0},
	TextAlignment -> Center
];
logo = StreamPlot[
	{\[Omega], -Sin[\[Theta]]}, {\[Theta], -2\[Pi], 2\[Pi]}, {\[Omega], -2\[Pi], 2\[Pi]},
	Epilog -> Text[title],
	Background -> White,
	StreamColorFunction -> (Blend[{Red, LightRed, White}, #5] &),
	StreamMarkers -> "Drop",
	FrameStyle -> Directive[Black, Thickness[.1]],
	FrameTicks -> None,
	PlotRangePadding -> None,
	ImagePadding -> None
]
file = Export[FileNameJoin[{NotebookDirectory[], "logo.png"}], logo, ImageSize -> {256, 256}];
Run["optipng " <> file];
