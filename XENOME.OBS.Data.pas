unit XENOME.OBS.Data;

interface

uses
  XENOME.OBS.Types;

type
  POBSData = ^TOBSData;
  POBSDataItem = ^TOBSDataItem;

  TOBSDataItem = record
    [volatile] Ref: Cardinal;
    Name: PAnsiChar;
    Parent: POBSData;
    HashHandle: Array[0..55] of Byte;
    Typ: TOBSDataType;
    NameLen: UInt64;
    DataLen: UInt64;
    DataSize: UInt64;
    DefaultLen: UInt64;
    DefaultSize: UInt64;
    AutoselectSize: UInt64;
    Capacity: UInt64;
  end;

  TOBSData = record
    [volatile] Ref: Cardinal;
    Json: PAnsiChar;
    Items: POBSDataItem;
  end;

  POBSDataArray = ^TOBSDataArray;
  TOBSDataArray = record
    [volatile] Ref: Cardinal;
    Objects: TOBSDArray;
  end;

  POBSDataNumber = ^TOBSDataNumber;
  TOBSDataNumber = record
	  Typ: TOBSDataNumberType;
    case Integer of
      0: (
        IntVal: Int64;
      );
      1: (
        DoubleVal: Double;
      );
  end;

implementation

end.
