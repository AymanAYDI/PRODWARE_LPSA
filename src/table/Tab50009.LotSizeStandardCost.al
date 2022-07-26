table 50009 "PWD Lot Size Standard Cost"
{
    DataClassification = CustomerContent;
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                                         |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.01
    // FE_LAPIERRETTE_PRO08.001: GR 15/02/2012: Multiple Standard Cost Calculate
    //                                          Creation
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+


    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(2; "Item category code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            DataClassification = CustomerContent;
        }
        field(3; "Lot Size"; Decimal)
        {
            Caption = 'Lot Size';
            DecimalPlaces = 0 : 5;
            MinValue = 1;
            DataClassification = CustomerContent;
        }
        field(4; "Standard Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Standard Cost';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Item category code", "Lot Size")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure FctInsertItemLine(CodPItemNo: Code[20]; CodPItemCatCode: Code[10])
    var
        RecLLotSize: Record "PWD Lot Size";
        RecLLotSizeStdCost: Record "PWD Lot Size Standard Cost";
    begin
        //===Line Inserting on update Item Costing Method To Standard========================
        RecLLotSize.Reset();
        RecLLotSize.SetRange("Item Category Code", CodPItemCatCode);
        if RecLLotSize.FindSet() then
            repeat
                RecLLotSizeStdCost.Reset();
                RecLLotSizeStdCost.SetRange("Item No.", CodPItemNo);
                RecLLotSizeStdCost.SetRange("Item category code", CodPItemCatCode);
                RecLLotSizeStdCost.SetRange("Lot Size", RecLLotSize."Lot Size");
                if not (RecLLotSizeStdCost.FindFirst()) then begin
                    RecLLotSizeStdCost.Init();
                    RecLLotSizeStdCost.Validate("Item No.", CodPItemNo);
                    RecLLotSizeStdCost.Validate("Item category code", CodPItemCatCode);
                    RecLLotSizeStdCost.Validate("Lot Size", RecLLotSize."Lot Size");
                    RecLLotSizeStdCost.Insert(true);
                end;
            until RecLLotSize.Next() = 0;
    end;
}

