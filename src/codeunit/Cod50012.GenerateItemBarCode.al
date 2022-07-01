codeunit 50012 "PWD GenerateItemBarCode"

{
    procedure GetJsonValueAsText(var JSonObject: JsonObject; Property: Text) Value: text
    var
        JsonValue: JsonValue;
    begin
        if not GetJsonValue(JSonObject, Property, JsonValue) then
            exit;
        Value := JsonValue.AsText;
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
        BaseURL: Text;
        TypeHelper: Codeunit "Type Helper";
    begin
        BaseURL := 'http://barcodes4.me';

        // %1/barcode/qr/%2.?value=%3&size=%4&ecclevel=%5'
        // http://barcodes4.me/barcode/[type]/[value].[imagetype]
        // if Barcode.Type = Barcode.Type::c39 then
        //     Arguments.URL := StrSubstNo('%1/barcode/c39/%2.%3',
        //                                 BaseURL,
        //                                 //GetOptionStringValue(Barcode.Type, Barcode.FieldNo(Type)),
        //                                 TypeHelper.UrlEncode(Barcode.Value),
        //                                 'jpg');
        // GetOptionStringValue(Barcode.Size, Barcode.FieldNo(Size)),
        // GetOptionStringValue(Barcode.ECCLevel, Barcode.FieldNo(ECCLevel)))
        // else
        //     Arguments.URL := StrSubstNo('%1/barcode/%2/%3.%4?istextdrawn=%5&isborderdrawn=%6&isreversecolor=%7',
        //                                 BaseURL,
        //                                 GetOptionStringValue(Barcode.Type, Barcode.FieldNo(Type)),
        //                                 TypeHelper.UrlEncode(Barcode.Value),
        //                                 GetOptionStringValue(Barcode.PictureType, Barcode.FieldNo(PictureType)),
        //                                 Format(Barcode.IncludeText, 0, 2),
        //                                 Format(Barcode.Border, 0, 2),
        //                                 Format(Barcode.ReverseColors, 0, 2));

        // Arguments.URL := 'https://www.bcgen.com/ssrs/demo-c128.aspx?D=1000000109023';                      //TEST1
        // Arguments.URL := 'https://barcode.tec-it.com/barcode.ashx?data=100000120264&code=Code128&dpi=96';  //TEST2

        Arguments.URL := 'https://barcode.tec-it.com/barcode.ashx?data=' + TypeHelper.UrlEncode(Barcode.Value) +
        '&code=Code128&multiplebarcodes=false&translate-esc=false&unit=Fit&dpi=96&imagetype=jpg';

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
        ResponseContent: HttpContent;
        InStr: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        Arguments.GetResponseContent(ResponseContent);
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        ResponseContent.ReadAs(InStr);
        Clear(Barcode.Picture);
        Barcode.Picture.ImportStream(InStr, Barcode.Value, 'image/jpg');
        Barcode.Modify(true);
    end;

    local procedure GetOptionStringValue(Value: Integer; fieldno: Integer): Text
    var
        FieldRec: Record Field;
    begin
        FieldRec.Get(Database::"PWD BarCode", fieldno);
        exit(SelectStr(Value + 1, FieldRec.OptionString));

    end;
}


