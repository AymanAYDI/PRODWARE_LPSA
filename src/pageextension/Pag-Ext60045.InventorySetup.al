pageextension 60045 "PWD InventorySetup" extends "Inventory Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 20/06/2017 :  CONFIGURATEUR ARTICLES
    //                - Add Tab Item Configurator with Fields Product Group Code  Dimension
    //                                                        LPSA Customer No.
    //                                                        STRATEGY Customer No.
    //                                                        Item Filter For Extern Ref
    // 
    // //>>LAP2.19
    // P24578_008.001 : LY 12/08/2019 : Export contrôle de gestion
    layout
    {
        addlast(Dimensions)
        {
            group("PWD Dimensions")
            {
                ShowCaption = false;
                field("PWD Item Category Dimension"; Rec."PWD Item Category Dimension")
                {
                    ApplicationArea = All;
                }
                field("PWD Product Group Dimension"; Rec."PWD Product Group Dimension")
                {
                    ApplicationArea = All;
                }
            }
        }
        addafter(Numbering)
        {
            group("PWD Specific")
            {
                Caption = 'Specific';
                field("PWD Item Filter Level 1"; Rec."PWD Item Filter Level 1")
                {
                    ApplicationArea = All;
                }
                field("PWD Item Filter Level 2"; Rec."PWD Item Filter Level 2")
                {
                    ApplicationArea = All;
                }
                field("PWD Item Filter Level 3"; Rec."PWD Item Filter Level 3")
                {
                    ApplicationArea = All;
                }
                field("PWD Item Filter Level 4"; Rec."PWD Item Filter Level 4")
                {
                    ApplicationArea = All;
                }
                group("PWD Export Closing File")
                {
                    Caption = 'Export Closing File';
                    field("PWD Closing Export DateFormula"; Rec."PWD Closing Export DateFormula")
                    {
                        ApplicationArea = All;
                    }
                    field("PWD Period for Inventory Cover"; Rec."PWD Period for Inventory Cover")
                    {
                        ApplicationArea = All;
                    }
                    field("PWD Path for Closing Export"; Rec."PWD Path for Closing Export")
                    {
                        ApplicationArea = All;

                        trigger OnAssistEdit()
                        var
                            CduLCommonDialogMgt: Codeunit "File management";
                            CstL50000: Label 'Open';
                            CstL50001: Label 'File';
                            CstL50002: Label 'File path too long, you should change of location.';
                            TxtLDirectoryPath: Text[250];
                        begin
                            //>>P24578_008.001
                            CLEAR(CduLCommonDialogMgt);
                            CLEAR(TxtLDirectoryPath);
                            TxtLDirectoryPath := CduLCommonDialogMgt.UploadFile(CstL50000, Rec."PWD Path for Closing Export" + CstL50001);
                            IF STRLEN(TxtLDirectoryPath) > MAXSTRLEN(Rec."PWD Path for Closing Export") THEN
                                ERROR(CstL50002)
                            ELSE
                                Rec.VALIDATE("PWD Path for Closing Export", TxtLDirectoryPath);
                            //<<P24578_008.001
                        end;
                    }
                    field("PWD Closing Sendor E-Mail"; Rec."PWD Closing Sendor E-Mail")
                    {
                        ApplicationArea = All;
                    }
                    field("PWD Recipient User ID"; Rec."PWD Recipient User ID")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group("PWD Item Configurator")
            {
                Caption = 'Item Configurator';
                field("PWD Product Group Code  Dimension"; Rec."PWD Product Group Code Dim")
                {
                    ApplicationArea = All;
                }
                field("PWD LPSA Customer No."; Rec."PWD LPSA Customer No.")
                {
                    ApplicationArea = All;
                }
                field("PWD STRATEGY Customer No."; Rec."PWD STRATEGY Customer No.")
                {
                    ApplicationArea = All;
                }
                field("PWD Item Filter For Extern Ref"; Rec."PWD Item Filter For Extern Ref")
                {
                    ApplicationArea = All;
                }
                field("PWD Path Link"; "PWD Path Link")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

