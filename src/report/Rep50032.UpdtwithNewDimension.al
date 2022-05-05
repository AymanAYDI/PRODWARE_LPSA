report 50032 "PWD Updt with New Dimension"
{
    // -----------------------------------------------------------------------------------------------
    //  Prodware - www.prodware.fr
    // -----------------------------------------------------------------------------------------------
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 05/09/2017 :  CONFIGURATEUR ARTICLE
    //                - new report
    // 
    // -----------------------------------------------------------------------------------------------

    Caption = 'Updt with New Dimension';
    Permissions = TableData "Item Ledger Entry" = r,
                  TableData "Sales Line" = r,
                  TableData "Purchase Line" = r,
                  TableData "Sales Shipment Line" = r,
                  TableData "Sales Invoice Line" = r,
                  TableData "Sales Cr.Memo Line" = r,
                  TableData "Purch. Rcpt. Line" = r,
                  TableData "Purch. Inv. Line" = r,
                  TableData "Purch. Cr. Memo Line" = r,
                  TableData "Dimension Value" = ri,
                  TableData "Default Dimension" = r,
                  //TODO:Table '"Ledger Entry Dimension"', "Production Document Dimension" and "Posted Document Dimension" are missing
                  //TableData "Ledger Entry Dimension" = ri,
                  //TableData "Production Document Dimension" = ri,
                  //TableData "Posted Document Dimension" = ri,
                  TableData "Production Order" = r,
                  TableData "Prod. Order Line" = r,
                  TableData "Prod. Order Component" = r,
                  TableData "Transfer Line" = r,
                  TableData "Transfer Shipment Line" = r,
                  TableData "Transfer Receipt Line" = r;
    ProcessingOnly = true;
    UsageCategory = none;

    dataset
    {
        dataitem("Default Dimension"; "Default Dimension")
        {
            DataItemTableView = SORTING("Table ID", "No.", "Dimension Code") WHERE("Table ID" = CONST(27));
            RequestFilterFields = "Table ID", "No.", "Dimension Code";
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemTableView = SORTING("Item No.", "Posting Date");

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtLdgrEntryDimension(
                      DATABASE::"Item Ledger Entry",
                      "Entry No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("Item No.", "Default Dimension"."No.");
                    SetFilter("Posting Date", DateFilter);
                end;
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemTableView = SORTING("Item No.", "Posting Date", "Item Ledger Entry Type", "Entry Type", "Variance Type", "Item Charge No.", "Location Code", "Variant Code");

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtLdgrEntryDimension(
                      DATABASE::"Value Entry",
                      "Entry No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("Item No.", "Default Dimension"."No.");
                    SetFilter("Posting Date", DateFilter);
                end;
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemTableView = SORTING(Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Document Type", "Shipment Date") WHERE(Type = CONST(Item));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtDocDimension(
                      DATABASE::"Sales Line",
                      "Document Type".AsInteger(),
                      "Document No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("No.", "Default Dimension"."No.");
                end;
            }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = CONST(Item));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtPstdDocDimension(
                      DATABASE::"Sales Shipment Line",
                      "Document No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("No.", "Default Dimension"."No.");
                    SetFilter("Posting Date", DateFilter);
                end;
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = CONST(Item));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtPstdDocDimension(
                      DATABASE::"Sales Invoice Line",
                      "Document No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("No.", "Default Dimension"."No.");
                    SetFilter("Posting Date", DateFilter);
                end;
            }
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = CONST(Item));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtPstdDocDimension(
                      DATABASE::"Sales Cr.Memo Line",
                      "Document No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("No.", "Default Dimension"."No.");
                    SetFilter("Posting Date", DateFilter);
                end;
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemTableView = SORTING(Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Document Type", "Expected Receipt Date") WHERE(Type = CONST(Item));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtDocDimension(
                      DATABASE::"Purchase Line",
                      "Document Type".AsInteger(),
                      "Document No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("No.", "Default Dimension"."No.");
                end;
            }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = CONST(Item));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtPstdDocDimension(
                      DATABASE::"Purch. Rcpt. Line",
                      "Document No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("No.", "Default Dimension"."No.");
                    SetFilter("Posting Date", DateFilter);
                end;
            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = CONST(Item));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtPstdDocDimension(
                      DATABASE::"Purch. Inv. Line",
                      "Document No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("No.", "Default Dimension"."No.");
                    SetFilter("Posting Date", DateFilter);
                end;
            }
            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = CONST(Item));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtPstdDocDimension(
                      DATABASE::"Purch. Cr. Memo Line",
                      "Document No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("No.", "Default Dimension"."No.");
                    SetFilter("Posting Date", DateFilter);
                end;
            }
            dataitem("Production Order"; "Production Order")
            {
                DataItemTableView = SORTING(Status, "No.") WHERE(Status = FILTER(<> Released), "Source Type" = CONST(Item));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "No.");

                    UpdtProdDocDimension(
                      DATABASE::"Production Order",
                      Status.AsInteger(),
                      "No.",
                      0,
                      0);
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("Source No.", "Default Dimension"."No.");
                end;
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.") WHERE(Status = FILTER(<> Released));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Prod. Order No.");

                    UpdtProdDocDimension(
                      DATABASE::"Prod. Order Line",
                      Status.AsInteger(),
                      "Prod. Order No.",
                      "Line No.",
                      0);
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("Item No.", "Default Dimension"."No.");
                end;
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.") WHERE(Status = FILTER(<> Released));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Prod. Order No.");

                    UpdtProdDocDimension(
                      DATABASE::"Prod. Order Component",
                      Status.AsInteger(),
                      "Prod. Order No.",
                      "Prod. Order Line No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("Item No.", "Default Dimension"."No.");
                end;
            }
            dataitem("Finished PO"; "Production Order")
            {
                DataItemTableView = SORTING(Status, "No.") WHERE(Status = CONST(Released));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "No.");

                    UpdtProdDocDimension(
                      DATABASE::"Production Order",
                      Status.AsInteger(),
                      "No.",
                      0,
                      0);
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("Source No.", "Default Dimension"."No.");
                    SetFilter("Ending Date", DateFilter);
                end;
            }
            dataitem("Finished PO Line"; "Prod. Order Line")
            {
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.") WHERE(Status = CONST(Released));

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Prod. Order No.");

                    UpdtProdDocDimension(
                      DATABASE::"Prod. Order Line",
                      Status.AsInteger(),
                      "Prod. Order No.",
                      "Line No.",
                      0);
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("Item No.", "Default Dimension"."No.");
                    SetFilter("Ending Date", DateFilter);
                end;
            }
            dataitem("Finished PO Component"; "Prod. Order Component")
            {
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.") WHERE(Status = CONST(Released));

                trigger OnAfterGetRecord()
                var
                    ProdHeader: Record "Production Order";
                begin
                    ProdHeader.SetRange(Status, Status);
                    ProdHeader.SetRange("No.", "Prod. Order No.");
                    ProdHeader.SetFilter("Ending Date", DateFilter);
                    if not ProdHeader.IsEmpty then begin
                        Window.Update(2, "Prod. Order No.");
                        UpdtProdDocDimension(
                          DATABASE::"Prod. Order Component",
                          Status.AsInteger(),
                          "Prod. Order No.",
                          "Prod. Order Line No.",
                          "Line No.");

                    end;
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("Item No.", "Default Dimension"."No.");
                end;
            }
            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemTableView = SORTING("Item No.");

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtDocDimension(
                      DATABASE::"Transfer Line",
                      6,
                      "Document No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("Item No.", "Default Dimension"."No.");
                end;
            }
            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemTableView = SORTING("Transfer Order No.", "Item No.", "Shipment Date");

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtPstdDocDimension(
                      DATABASE::"Transfer Shipment Line",
                      "Document No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("Item No.", "Default Dimension"."No.");
                    SetFilter("Shipment Date", DateFilter);
                end;
            }
            dataitem("Transfer Receipt Line"; "Transfer Receipt Line")
            {
                DataItemTableView = SORTING("Document No.", "Line No.");

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");

                    UpdtPstdDocDimension(
                      DATABASE::"Transfer Receipt Line",
                      "Document No.",
                      "Line No.");
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(1, TableCaption);
                    SetRange("Item No.", "Default Dimension"."No.");
                    SetFilter("Receipt Date", DateFilter);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(3, "Default Dimension"."Dimension Code");
                Window.Update(4, "Default Dimension"."No.");
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
                Message(CstTxt004);
            end;

            trigger OnPreDataItem()
            begin
                DimensionCode := GetFilter("Dimension Code");
                if DimensionCode = '' then
                    Error(CstTxt000);

                Window.Open(CstTxt005 + CstTxt002 + CstTxt003);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DimensionCode; DimensionCode)
                    {
                        Caption = 'Axe';
                        TableRelation = Dimension;
                        ApplicationArea = All;
                    }
                    field(DateFilter; DateFilter)
                    {
                        Caption = 'Date Filter';
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            // ApplicationManagement: Codeunit ApplicationManagement;
                            FilterTokens: Codeunit "Filter Tokens";
                        begin
                            FilterTokens.MakeDateFilter(DateFilter);
                            ItemStatisticsBuffer.SetFilter("Date Filter", DateFilter);
                            DateFilter := ItemStatisticsBuffer.GetFilter("Date Filter");
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if DateFilter = '' then
            Error(CstTxt001);
    end;

    var
        ItemStatisticsBuffer: Record "Item Statistics Buffer";
        DimensionCode: Code[150];
        Window: Dialog;
        CstTxt000: Label 'Un axe est obligatoire.';
        CstTxt001: Label 'Un filtre date est obligatoire.';
        CstTxt002: Label 'Traitement tables #1#################\\';
        CstTxt003: Label 'Document             #2#################';
        CstTxt004: Label 'Update Finished.';
        CstTxt005: Label 'Mise à jour Axe #3############### de l''article #4##################\';
        DateFilter: Text[30];


    procedure UpdtLdgrEntryDimension(TableNo: Integer; EntryNo: Integer)
    var
    //TODO:   LdgrEntryDimension: Record "Ledger Entry Dimension";
    //LdgrEntryDimension: Record "Ledger Entry Dimension";
    //DimSetEntry: Record "Dimension Set Entry";
    begin

        // LdgrEntryDimension."Entry No." := EntryNo;
        // LdgrEntryDimension."Dimension Code" := "Default Dimension"."Dimension Code";
        // LdgrEntryDimension."Dimension Value Code" := "Default Dimension"."Dimension Value Code";
        // if not LdgrEntryDimension.Insert then;
        // if not LdgrEntryDimension.Insert then;
    end;


    procedure UpdtDocDimension(TableNo: Integer; DocType: Option; DocNo: Code[20]; DocLineNo: Integer)
    var
    //TODO: Table 'Document Dimension' is missing
    // DocumentDimension: Record "Document Dimension";
    begin
        // DocumentDimension."Table ID" := TableNo;
        // DocumentDimension."Document Type" := DocType;
        // DocumentDimension."Document No." := DocNo;
        // DocumentDimension."Line No." := DocLineNo;
        // DocumentDimension."Dimension Code" := "Default Dimension"."Dimension Code";
        // DocumentDimension."Dimension Value Code" := "Default Dimension"."Dimension Value Code";
        // if not DocumentDimension.Insert then;
    end;


    procedure UpdtProdDocDimension(TableID: Integer; Status: Option; DocumentNo: Code[20]; LineNo: Integer; SublineNo: Integer)
    var
    //TODO:Table 'Production Document Dimension' is missing
    //ProdDocumentDimension: Record "Production Document Dimension";
    begin
        // ProdDocumentDimension."Table ID" := TableID;
        // ProdDocumentDimension."Document Status" := Status;
        // ProdDocumentDimension."Document No." := DocumentNo;
        // ProdDocumentDimension."Document Line No." := LineNo;
        // ProdDocumentDimension."Line No." := SublineNo;
        // ProdDocumentDimension."Dimension Code" := "Default Dimension"."Dimension Code";
        // ProdDocumentDimension."Dimension Value Code" := "Default Dimension"."Dimension Value Code";
        // if not ProdDocumentDimension.Insert then;
    end;


    procedure UpdtPstdDocDimension(TableNo: Integer; DocNo: Code[20]; DocLineNo: Integer)
    var
    //TODO: table 'Production Document Dimension' is missing
    //PstdDocumentDimension: Record "Posted Document Dimension";
    begin
        // PstdDocumentDimension."Table ID" := TableNo;
        // PstdDocumentDimension."Document No." := DocNo;
        // PstdDocumentDimension."Line No." := DocLineNo;
        // PstdDocumentDimension."Dimension Code" := "Default Dimension"."Dimension Code";
        // PstdDocumentDimension."Dimension Value Code" := "Default Dimension"."Dimension Value Code";
        // if not PstdDocumentDimension.Insert then;
    end;
}

