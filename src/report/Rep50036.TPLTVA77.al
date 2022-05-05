report 50036 "PWD TPL TVA 7.7"
{
    // -------------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // -------------------------------------------------------------------------------
    // 
    // //>>VATRateChange by Prodware
    // TI399821 RO : 11/01/2018 : Suite ticket TI399821
    // 
    // -------------------------------------------------------------------------------

    ProcessingOnly = true;
    UsageCategory = none;
    dataset
    {
        dataitem(Customer; Customer)
        {

            trigger OnAfterGetRecord()
            begin
                IntGCounter -= 1;
                BDialog.Update(1, IntGCounter);

                if Customer."VAT Bus. Posting Group" = '7.7' then begin
                    Customer."VAT Bus. Posting Group" := 'H3';
                    Customer.Modify();
                end;
            end;

            trigger OnPostDataItem()
            begin
                BDialog.Close();
            end;

            trigger OnPreDataItem()
            begin
                IntGCounter := Count;
                BDialog.Open('Enregistrements Client restants #1#############');
            end;
        }
        dataitem("Sales Line"; "Sales Line")
        {

            trigger OnAfterGetRecord()
            begin
                IntGCounter -= 1;
                BDialog.Update(1, IntGCounter);

                if "Sales Line"."Document No." = 'CC170857' then CurrReport.Skip();
                if "Sales Line"."Document No." = 'CC171392' then CurrReport.Skip();

                if ("Sales Line"."VAT Bus. Posting Group" = '7.7') and
                   ("Sales Line"."Quantity Shipped" = 0) then begin
                    "Sales Line"."VAT Bus. Posting Group" := 'H3';
                    "Sales Line".Modify();
                    RecGSalesHeader.Get("Sales Line"."Document Type", "Sales Line"."Document No.");
                    RecGSalesHeader."VAT Bus. Posting Group" := 'H3';
                    RecGSalesHeader.Modify();
                end;
            end;

            trigger OnPostDataItem()
            begin
                BDialog.Close();
            end;

            trigger OnPreDataItem()
            begin
                IntGCounter := Count;
                BDialog.Open('Enregistrements Ligne vente restants #1#############');
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
        RecGSalesHeader: Record "Sales Header";
        BDialog: Dialog;
        IntGCounter: Integer;
}

