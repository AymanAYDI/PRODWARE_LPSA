codeunit 50012 "PWD GenerateItemBarCode"

{
    procedure GetJsonValueAsText(var JSonObject: JsonObject; Property: Text) Value: text
    var
        JsonValue: JsonValue;
    begin
        if not GetJsonValue(JSonObject, Property, JsonValue) then
            exit;
        Value := JsonValue.AsText();
    end;

    procedure GetJsonValue(var JSonObject: JsonObject; Property: Text; var JsonValue: JsonValue): Boolean
    var
        JsonToken: JsonToken;
    begin
        if not JSonObject.Get(Property, JsonToken) then
            exit;
        JsonValue := JsonToken.AsValue();
        exit(true);
    end;

    procedure GenerateBarcode(var Barcode: Record "PWD BarCode")
    begin
        DoGenerateBarcode(Barcode);
    end;

    local procedure DoGenerateBarcode(var Barcode: Record "PWD BarCode")
    var
        Arguments: Record "PWD RESTWebServiceArguments" temporary;
    begin
        InitArguments(Arguments, Barcode);

        if not CallWebService(Arguments) then
            exit;
        SaveResult(Arguments, Barcode);
    end;

    local procedure InitArguments(var Arguments: Record "PWD RESTWebServiceArguments" temporary; Barcode: Record "PWD BarCode")
    var
        TypeHelper: Codeunit "Type Helper";
    begin

        Arguments.URL := 'https://barcode.tec-it.com/barcode.ashx?data=' + TypeHelper.UrlEncode(Barcode.Value) +
        '&code=Code39&multiplebarcodes=false&translate-esc=false&unit=Fit&dpi=96&imagetype=jpg';
        Arguments.RestMethod := Arguments.RestMethod::get;
    end;

    local procedure CallWebService(var Arguments: Record "PWD RESTWebServiceArguments" temporary) Success: Boolean
    var
        RESTWebService: codeunit "PWD PWDRESTWebServiceCode";
    begin
        Success := RESTWebService.CallRESTWebService(Arguments);
    end;

    local procedure SaveResult(var Arguments: Record "PWD RESTWebServiceArguments" temporary; var Barcode: Record "PWD BarCode")
    var
        TempBlob: Codeunit "Temp Blob";
        ResponseContent: HttpContent;
        InStr: InStream;

    begin
        Arguments.GetResponseContent(ResponseContent);
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        ResponseContent.ReadAs(InStr);
        Clear(Barcode.Picture);
        Barcode.Picture.ImportStream(InStr, Barcode.Value, 'image/jpg');
        Barcode.Modify(true);
    end;

    // local procedure GetOptionStringValue(Value: Integer; fieldno: Integer): Text
    // var
    //     FieldRec: Record Field;
    // begin
    //     FieldRec.Get(Database::"PWD BarCode", fieldno);
    //     exit(SelectStr(Value + 1, FieldRec.OptionString));

    // end;
}


