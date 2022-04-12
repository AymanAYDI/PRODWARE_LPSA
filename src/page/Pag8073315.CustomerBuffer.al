page 8073315 "PWD Customer Buffer"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FEMOT.001:GR 29/06/2011  Connector management
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Customer Buffer';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Customer Buffer";

    layout
    {
        area(content)
        {
            repeater(Control1100294000)
            {
                ShowCaption = false;
                field("Entry No."; "Entry No.")
                {
                }
                field("Connector Values Entry No."; "Connector Values Entry No.")
                {
                }
                field("Partner Code"; "Partner Code")
                {
                }
                field("Message Code"; "Message Code")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field(Status; Status)
                {
                }
                field(Processed; Processed)
                {
                }
                field("Processed Date"; "Processed Date")
                {
                }
                field("Error Message"; "Error Message")
                {
                }
                field("Action"; Action)
                {
                }
                field("RecordID Created"; "RecordID Created")
                {
                }
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Name 2"; "Name 2")
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(City; City)
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100294006; Links)
            {
                Visible = false;
            }
            systempart(Control1100294002; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Action1100294044)
            {
                Caption = 'Line';
                action(Action1100294045)
                {
                    Caption = 'Process action';

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
                    begin
                        CduLBufferManagement.FctProcessCustomer(Rec);
                    end;
                }
                action(Action1100294052)
                {
                    Caption = 'Process selected actions';

                    trigger OnAction()
                    begin
                        FctProcessSelected();
                    end;
                }
                action(Action1100294053)
                {
                    Caption = 'Show Error Message';

                    trigger OnAction()
                    begin
                        FctShowErrorMessage();
                    end;
                }
                separator(Action1100294046)
                {
                }
                action(Action1100294050)
                {
                    Caption = 'Purge selected';

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
                        RecLCustomerBuffer: Record "Customer Buffer";
                    begin
                        CurrPage.SETSELECTIONFILTER(RecLCustomerBuffer);
                        CduLBufferManagement.FctPurgeCustomer(RecLCustomerBuffer);
                    end;
                }
                separator(Action1100294051)
                {
                }
                action(Action1100294047)
                {
                    Caption = 'Show Document';
                    Image = View;

                    trigger OnAction()
                    var
                        CduLBufferManagement: Codeunit "Buffer Management";
                    begin
                        CduLBufferManagement.FctShowCustomer(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        FctGetBufferLinked();
    end;

    var
        CduGBufferManagement: Codeunit "Buffer Management";
        RecGPEBCustomerBuffer: Record "PEB Customer Buffer";
        RecGWMSCustomerBuffer: Record "WMS Customer Buffer";


    procedure FctGetBufferLinked()
    begin
        //Insérer les différents Tables liées au export Natif.
        IF RecGPEBCustomerBuffer.GET("Entry No.") THEN;
        IF RecGWMSCustomerBuffer.GET("Entry No.") THEN;
    end;


    procedure FctProcessSelected()
    var
        RecLCustomerBuffer: Record "Customer Buffer";
        RecordRef: RecordRef;
    begin
        CurrPage.SETSELECTIONFILTER(RecLCustomerBuffer);
        RecordRef.OPEN(DATABASE::"Customer Buffer", FALSE, COMPANYNAME);
        RecordRef.SETTABLE(RecLCustomerBuffer);
        CduGBufferManagement.FctMultiProcessLine(RecordRef);
    end;


    procedure FctShowErrorMessage()
    var
        RecordRef: RecordRef;
    begin
        RecordRef.GETTABLE(Rec);
        CduGBufferManagement.FctReadBlob(RecordRef);
    end;
}

