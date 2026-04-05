unit XENOME.OBS.Misc;

interface

type
  pUT_hash_table = ^UT_hash_table;
  pUT_hash_bucket = ^UT_hash_bucket;
  pUT_hash_handle = ^UT_hash_handle;

  UT_hash_table = record
    Buckets: pUT_hash_bucket;
    NumBuckets: Cardinal;
    Log2NumBuckets: Cardinal;
    NumItems: Cardinal;
    Tail: pUT_hash_handle;
    Hho: UInt64;
    IdealChainMaxLen: Cardinal;
    NonIdealItems: Cardinal;
    IneffExpands: Cardinal;
    NoExpand: Cardinal;
    Signature: Cardinal;
  end;

  UT_hash_bucket = record
    HHHead: pUT_hash_handle;
    Count: Cardinal;
    ExpandMult: Cardinal;
  end;

  UT_hash_handle = record
    tbl: pUT_hash_table;
    Prev: Pointer;
    Next: Pointer;
    HHPrev: pUT_hash_handle;
    HHNext: pUT_hash_handle;
    Key: Pointer;
    KeyLen: Cardinal;
    Hashv: Cardinal;
  end;

implementation

end.
