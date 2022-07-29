table 50019 "PWD BarCode"
{
    Caption = 'PWD BarCode';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PrimaryKey; Guid)
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; Value; Text[250])
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = " ",c39,c128a,c128b,c128c,i2of5,qr;
            OptionCaption = 'Select a Type,Code 39,Code 128a,Code 128b,Code 128c,2 of 5 Interleaved,QR Code';
            DataClassification = CustomerContent;
        }
        field(4; Width; Integer)
        {
            Caption = 'Width';
            InitValue = 250;
            DataClassification = CustomerContent;
        }
        field(5; Height; Integer)
        {
            Caption = 'Height';
            InitValue = 100;
            DataClassification = CustomerContent;
        }
        field(6; IncludeText; Boolean)
        {
            Caption = 'Include Text';
            DataClassification = CustomerContent;
        }
        field(7; Border; Boolean)
        {
            Caption = 'Border';
            DataClassification = CustomerContent;
        }
        field(8; ReverseColors; Boolean)
        {
            Caption = 'Reverse Colors';
            DataClassification = CustomerContent;
        }
        field(9; ECCLevel; Option)
        {
            Caption = 'ECC Level';
            OptionMembers = "0","1","2","3";
            OptionCaption = 'Low (L),Medium-Low (M),Medium-High (Q),High (H)';
            DataClassification = CustomerContent;
        }
        field(10; Size; Option)
        {
            Caption = 'Size';
            OptionMembers = "1","2","3","4","5","6","7","8","9","10";
            OptionCaption = '21x21,42x42,63x63,84x84,105x105,126x126,147x147,168x168,189x189,210x210';
            InitValue = "5";
            DataClassification = CustomerContent;
        }
        field(11; PictureType; Option)
        {
            Caption = 'Picture Type';
            OptionMembers = png,gif,jpg;
            OptionCaption = 'png,gif,jpg';
            DataClassification = CustomerContent;
        }
        field(12; Picture; MediaSet)
        {
            Caption = 'Picture';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = false;
        }
    }

    trigger OnInsert();
    begin
        PrimaryKey := CreateGuid();
    end;

    procedure Fct_GenerateBarcode()
    var
        GenerateBarcodeCode: Codeunit "PWD GenerateItemBarCode";
    begin
        GenerateBarcodeCode.GenerateBarcode(Rec);
    end;


}
