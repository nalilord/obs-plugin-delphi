unit XENOME.OBS.VideoScaler;

interface

type
  SwsContext = record
  end;

  POBSVideoScaler = ^TOBSVideoScaler;
  TOBSVideoScaler = record
    Swscale: ^SwsContext;
    SrcHeight: Integer;
    DstHeights: Array [0..3] of Integer;
    DstPointers: Array[0..3] of PAnsiChar;
    DstLineSizes: Array [0..3] of Integer;
  end;

implementation

end.
