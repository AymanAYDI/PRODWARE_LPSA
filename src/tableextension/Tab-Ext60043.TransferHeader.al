tableextension 60043 "PWD TransferHeader" extends "Transfer Header"
{
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Prodware : www.prodware.fr
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 
    // //>>LAP2.00
    //       -Add Field "Sales Order No." ID : 50005
    //       -Add Function FillTransfer-to info with cmd()
    //       -Add Function FillTransfer-to info Location()
    //       -Modify code in trigger Transfer-to Code - OnValidate()
    //       -Modify code in trigger Transfer-from Code - OnValidate()
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50005; "PWD Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Description = 'LAP2.00';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));

            trigger OnValidate()
            var
                TransLine: Record "Transfer Line";
                DefaultNumber: Option " ",Shipment,Receipt;
            begin
                TestStatusOpen();

                TransLine.SetRange("Document No.", "No.");
                if TransLine.Find('-') then
                    repeat
                        if (TransLine."Quantity Shipped" < TransLine.Quantity) and
                           (DefaultNumber = DefaultNumber::" ") then
                            DefaultNumber := DefaultNumber::Shipment;
                        if (TransLine."Quantity Received" < TransLine.Quantity) and
                           (DefaultNumber = DefaultNumber::" ") then
                            DefaultNumber := DefaultNumber::Receipt;
                    until (TransLine.Next() = 0) or (DefaultNumber > 0);
                if DefaultNumber <> 0 then
                    Error(CstG001);


                if "PWD Sales Order No." = '' then
                    "FillTransfer-to info Location"()
                else
                    "FillTransfer-to info with cmd"();
            end;
        }
    }

    procedure "FillTransfer-to info with cmd"()  //TODO: Lappel de la fonction n'est pas possible, il y'a pas un evenement liée
    var
        RecLSalesHeader: Record "Sales Header";
    begin

        if (RecLSalesHeader.Get(RecLSalesHeader."Document Type"::Order, "PWD Sales Order No.")) then begin
            "Transfer-to Name" := RecLSalesHeader."Ship-to Name";
            "Transfer-to Name 2" := RecLSalesHeader."Ship-to Name 2";
            "Transfer-to Address" := RecLSalesHeader."Ship-to Address";
            "Transfer-to Address 2" := RecLSalesHeader."Ship-to Address 2";
            "Transfer-to Post Code" := RecLSalesHeader."Ship-to Post Code";
            "Transfer-to City" := RecLSalesHeader."Ship-to City";
            "Transfer-to Contact" := RecLSalesHeader."Ship-to Contact";
            Modify();
        end;
    end;

    procedure "FillTransfer-to info Location"()  //TODO: Lappel de la fonction n'est pas possible, il y'a pas un evenement liée
    var
        Location: Record Location;
        TransferRoute: Record "Transfer Route";
        TransLine: Record "Transfer Line";
    begin

        if Location.Get("Transfer-to Code") then begin
            "Transfer-to Name" := Location.Name;
            "Transfer-to Name 2" := Location."Name 2";
            "Transfer-to Address" := Location.Address;
            "Transfer-to Address 2" := Location."Address 2";
            "Transfer-to Post Code" := Location."Post Code";
            "Transfer-to City" := Location.City;
            "Transfer-to County" := Location.County;
            "Trsf.-to Country/Region Code" := Location."Country/Region Code";
            "Transfer-to Contact" := Location.Contact;
            "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
            TransferRoute.GetTransferRoute(
              "Transfer-from Code", "Transfer-to Code", "In-Transit Code",
              "Shipping Agent Code", "Shipping Agent Service Code");
            TransferRoute.GetShippingTime(
              "Transfer-from Code", "Transfer-to Code",
              "Shipping Agent Code", "Shipping Agent Service Code",
              "Shipping Time");
            TransferRoute.CalcReceiptDate(
              "Shipment Date",
              "Receipt Date",
              "Shipping Time",
              "Outbound Whse. Handling Time",
              "Inbound Whse. Handling Time",
              "Transfer-from Code",
              "Transfer-to Code",
              "Shipping Agent Code",
              "Shipping Agent Service Code");
            TransLine.LockTable();
            TransLine.SetRange("Document No.", "No.");
            if TransLine.FindSet() then;
            Modify();
        end;
    end;

    var
        CstG001: Label 'You cannot modify Sales Order No., T.O. has already a post';
}

