unit uFuncoes;

interface

uses
  sysUtils, strUtils;


function SomenteNumeros(Key: Char; EhDecimal: Boolean = False): Char;
function CountStr(const AString, SubStr : String ) : Integer ;
function StringToFloat(NumString: String): Double;
function StringToFloatDef(const NumString : String ; const DefaultValue : Double  ) : Double ;

implementation

function  SomenteNumeros(Key: Char; EhDecimal: Boolean = False): Char;
begin
  if key='0' then
    result := Key
  Else if key='1' then
    result := Key
  Else if key='2' then
    result := Key
  Else if key='3' then
    result := Key
  Else if key='4' then
    result := Key
  Else if key='5' then
    result := Key
  Else if key='6' then
    result := Key
  Else if key='7' then
    result := Key
  Else if key='8' then
    result := Key
  Else if key='9' then
    result := Key
  Else if key=chr(8) then
    result := Key
  Else if (key=',') and EhDecimal then
    result := Key
  Else if (key='.') and EhDecimal then
    result := ','
  Else
    result := #0;
end;

function CountStr(const AString, SubStr : String ) : Integer ;
Var
  ini : Integer ;
begin
  result := 0 ;
  if SubStr = '' then exit ;
  ini := Pos( SubStr, AString ) ;
  while ini > 0 do
  begin
     Result := Result + 1 ;
     ini    := PosEx( SubStr, AString, ini + 1 ) ;
  end ;
end ;

function StringToFloat(NumString: String): Double;
var
  DS: Char;
begin
  NumString := Trim(NumString);
  DS := FormatSettings.DecimalSeparator;
  if DS <> '.' then
    NumString := StringReplace(NumString, '.', DS, [rfReplaceAll]);
  if DS <> ',' then
    NumString := StringReplace(NumString, ',', DS, [rfReplaceAll]);
  while CountStr(NumString, DS) > 1 do
    NumString := StringReplace(NumString, DS, '', []);
  Result := StrToFloat(NumString);
end;

function StringToFloatDef(const NumString : String ; const DefaultValue : Double  ) : Double ;
begin
  if NumString.Trim.IsEmpty then
     Result := DefaultValue
  else
   begin
     try
        Result := StringToFloat( NumString ) ;
     except
        Result := DefaultValue ;
     end ;
   end;
end ;

end.
