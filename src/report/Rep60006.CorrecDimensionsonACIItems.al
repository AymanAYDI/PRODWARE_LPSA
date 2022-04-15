report 60006 "Correc Dimensions on ACI Items"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            var
                RecLDefDim: Record "Default Dimension";
                RecLDefDim2: Record "Default Dimension";
            begin
                if StrPos("No.", 'CTRL') > 0 then
                    CurrReport.Skip();

                if RecLDefDim2.Get(27, "No.", 'ARTICLE_ROLEX') then begin
                    RecLDefDim.Init();
                    RecLDefDim."Table ID" := 27;
                    RecLDefDim."No." := "No.";
                    RecLDefDim."Dimension Code" := 'ARTICLE_ROLEX';
                    RecLDefDim."Dimension Value Code" := '4089323';
                    RecLDefDim."Value Posting" := RecLDefDim."Value Posting"::" ";
                    RecLDefDim.Insert(true);
                    RecLDefDim2.Delete();
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("No.", '1051*');
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

    trigger OnPostReport()
    begin
        Message('Terminé');
    end;
}

