report 99087 "PWD Update Centre cout"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateCentrecout.rdl';

    dataset
    {
        dataitem(Item2; Item)
        {
            DataItemTableView = WHERE("Location Code" = FILTER('ACI'), Description = CONST('NICOPA'));

            trigger OnAfterGetRecord()
            begin
                /*
                IF COPYSTR(Item2."No.",1,4) = '1051' THEN
                  CreateC;
                IF COPYSTR(Item2."No.",1,4) = '5451' THEN
                  CreateC;
                IF COPYSTR(Item2."No.",1,4) = '8051' THEN
                  CreateC;
                IF COPYSTR(Item2."No.",1,4) = '9951' THEN
                  CreateC;
                */

            end;
        }
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = WHERE("Location Code" = CONST('ACI'));

            trigger OnAfterGetRecord()
            var
                RecLItem: Record Item;
                RecL349: Record "Default Dimension";
            begin
                if RecLItem.Get("Prod. Order Line"."Item No.") then begin
                    RecL349.Reset;
                    RecL349.SetRange("Table ID", 27);
                    RecL349.SetRange("No.", RecLItem."No.");
                    if RecL349.FindFirst then
                        repeat
                            RecProdOrder.Reset;

                            //Table ID,Document Status,Document No.,Document Line No.,Line No.,Dimension Code
                            if not RecProdOrder.Get(5406,
                              "Prod. Order Line".Status,
                              "Prod. Order Line"."Prod. Order No.",
                              "Prod. Order Line"."Line No.",
                              0,
                              RecL349."Dimension Code") then begin
                                RecProdOrder.Init;
                                RecProdOrder.Validate("Table ID", 5406);
                                RecProdOrder.Validate("Document Status", "Prod. Order Line".Status);
                                RecProdOrder.Validate("Document No.", "Prod. Order Line"."Prod. Order No.");
                                RecProdOrder.Validate("Document Line No.", "Prod. Order Line"."Line No.");
                                RecProdOrder.Validate("Line No.", 0);
                                RecProdOrder.Validate("Dimension Code", RecL349."Dimension Code");
                                RecProdOrder.Validate("Dimension Value Code", RecL349."Dimension Value Code");
                                RecProdOrder.Insert;
                            end;
                        until RecL349.Next = 0;
                end;
            end;
        }
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = WHERE(Type = CONST(Item), "Location Code" = CONST('ACI'));

            trigger OnAfterGetRecord()
            var
                RecDimSale: Record "Document Dimension";
                RecLItem: Record Item;
                RecL349: Record "Default Dimension";
            begin
                if RecLItem.Get("No.") then begin
                    RecL349.Reset;
                    RecL349.SetRange("Table ID", 27);
                    RecL349.SetRange("No.", RecLItem."No.");
                    if RecL349.FindFirst then
                        repeat
                            RecDimSale.Reset;
                            if not RecDimSale.Get(37,
                              "Sales Line"."Document Type",
                              "Sales Line"."Document No.",
                              "Sales Line"."Line No.",
                              RecL349."Dimension Code") then begin
                                RecDimSale.Init;
                                RecDimSale.Validate("Table ID", 37);
                                RecDimSale.Validate("Document Type", "Sales Line"."Document Type");
                                RecDimSale.Validate("Document No.", "Sales Line"."Document No.");
                                RecDimSale.Validate("Line No.", "Sales Line"."Line No.");
                                RecDimSale.Validate("Dimension Code", RecL349."Dimension Code");
                                RecDimSale.Validate("Dimension Value Code", RecL349."Dimension Value Code");
                                RecDimSale.Insert;
                            end;
                        until RecL349.Next = 0;
                end;
            end;
        }
        dataitem("Prod. Order Component"; "Prod. Order Component")
        {
            DataItemTableView = WHERE("Location Code" = CONST('ACI'));

            trigger OnAfterGetRecord()
            var
                RecLItem: Record Item;
                RecL349: Record "Default Dimension";
            begin
                if RecLItem.Get("Prod. Order Line"."Item No.") then begin
                    RecL349.Reset;
                    RecL349.SetRange("Table ID", 27);
                    RecL349.SetRange("No.", RecLItem."No.");
                    if RecL349.FindFirst then
                        repeat
                            RecProdOrder.Reset;


                            if not RecProdOrder.Get(5407,
                              "Prod. Order Component".Status,
                              "Prod. Order Component"."Prod. Order No.",
                              "Prod. Order Component"."Prod. Order Line No.",
                              "Prod. Order Component"."Line No.",
                              RecL349."Dimension Code") then begin
                                RecProdOrder.Init;
                                RecProdOrder.Validate("Table ID", 5407);
                                RecProdOrder.Validate("Document Status", "Prod. Order Component".Status);
                                RecProdOrder.Validate("Document No.", "Prod. Order Component"."Prod. Order No.");
                                RecProdOrder.Validate("Document Line No.", "Prod. Order Component"."Prod. Order Line No.");
                                RecProdOrder.Validate("Line No.", "Prod. Order Component"."Line No.");
                                RecProdOrder.Validate("Dimension Code", RecL349."Dimension Code");
                                RecProdOrder.Validate("Dimension Value Code", RecL349."Dimension Value Code");
                                RecProdOrder.Insert;
                            end;
                        until RecL349.Next = 0;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        RecProdOrder: Record "Production Document Dimension";


    procedure CreateC()
    var
        RecL342: Record "Default Dimension";
    begin
        if not RecL342.Get(27, Item2."No.", 'PROFIT') then begin
            RecL342.Init;
            RecL342.Validate("Table ID", 27);
            RecL342.Validate("No.", Item2."No.");
            RecL342.Validate("Dimension Code", 'PROFIT');
            RecL342.Validate("Dimension Value Code", '19.10003');
            RecL342.Validate("Value Posting", RecL342."Value Posting"::"Code Mandatory");
            RecL342.Insert(true);
        end;
    end;
}

