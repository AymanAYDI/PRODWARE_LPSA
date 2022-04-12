report 60004 "Update Dimensions on ACI Items"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING ("No.");

            trigger OnAfterGetRecord()
            var
                RecLDefDim: Record "Default Dimension";
                RecLDocDim: Record "Document Dimension";
                RecLPurchLine: Record "Purchase Line";
            begin
                if StrPos("No.", 'CTRL') > 0 then
                    CurrReport.Skip;

                if RecLDefDim.Get(27, "No.", 'ARTICLE_ROLEX') then begin
                    RecLDefDim."Dimension Value Code" := '4089323';
                    RecLDefDim."Value Posting" := RecLDefDim."Value Posting"::" ";
                    RecLDefDim.Modify(true);
                end else begin
                    RecLDefDim.Init;
                    RecLDefDim."Table ID" := 27;
                    RecLDefDim."No." := "No.";
                    RecLDefDim."Dimension Code" := 'ARTICLE_ROLEX';
                    RecLDefDim."Dimension Value Code" := '4089323';
                    RecLDefDim."Value Posting" := RecLDefDim."Value Posting"::" ";
                    RecLDefDim.Insert(true);
                end;

                if RecLDefDim.Get(27, "No.", 'COUT') then begin
                    RecLDefDim."Dimension Value Code" := '19.20112';
                    RecLDefDim."Value Posting" := RecLDefDim."Value Posting"::"Code Mandatory";
                    RecLDefDim.Modify(true);
                end else begin
                    RecLDefDim.Init;
                    RecLDefDim."Table ID" := 27;
                    RecLDefDim."No." := "No.";
                    RecLDefDim."Dimension Code" := 'COUT';
                    RecLDefDim."Dimension Value Code" := '19.20112';
                    RecLDefDim."Value Posting" := RecLDefDim."Value Posting"::"Code Mandatory";
                    RecLDefDim.Insert(true);
                end;

                if RecLDefDim.Get(27, "No.", 'PROFIT') then begin
                    RecLDefDim."Dimension Value Code" := '19.10003';
                    RecLDefDim."Value Posting" := RecLDefDim."Value Posting"::"Code Mandatory";
                    RecLDefDim.Modify(true);
                end else begin
                    RecLDefDim.Init;
                    RecLDefDim."Table ID" := 27;
                    RecLDefDim."No." := "No.";
                    RecLDefDim."Dimension Code" := 'PROFIT';
                    RecLDefDim."Dimension Value Code" := '19.10003';
                    RecLDefDim."Value Posting" := RecLDefDim."Value Posting"::"Code Mandatory";
                    RecLDefDim.Insert(true);
                end;

                RecLPurchLine.Reset;
                RecLPurchLine.SetCurrentKey(Type, "No.");
                RecLPurchLine.SetRange(Type, RecLPurchLine.Type::Item);
                RecLPurchLine.SetRange("No.", "No.");
                if RecLPurchLine.FindSet(true, false) then
                    repeat
                        if RecLDocDim.Get(39, RecLPurchLine."Document Type", RecLPurchLine."Document No.", RecLPurchLine."Line No.",
                                'ARTICLE_ROLEX') then begin
                            RecLDocDim."Dimension Value Code" := '4089323';
                            RecLDocDim.Modify(true);
                        end else begin
                            RecLDocDim.Init;
                            RecLDocDim."Table ID" := 39;
                            RecLDocDim."Document Type" := RecLPurchLine."Document Type";
                            RecLDocDim."Document No." := RecLPurchLine."Document No.";
                            RecLDocDim."Line No." := RecLPurchLine."Line No.";
                            RecLDocDim."Dimension Code" := 'ARTICLE_ROLEX';
                            RecLDocDim."Dimension Value Code" := '4089323';
                            RecLDocDim.Insert(true);
                        end;

                        if RecLDocDim.Get(39, RecLPurchLine."Document Type", RecLPurchLine."Document No.", RecLPurchLine."Line No.",
                                'COUT') then begin
                            RecLDocDim."Dimension Value Code" := '19.20112';
                            RecLDocDim.Modify(true);
                        end else begin
                            RecLDocDim.Init;
                            RecLDocDim."Table ID" := 39;
                            RecLDocDim."Document Type" := RecLPurchLine."Document Type";
                            RecLDocDim."Document No." := RecLPurchLine."Document No.";
                            RecLDocDim."Line No." := RecLPurchLine."Line No.";
                            RecLDocDim."Dimension Code" := 'COUT';
                            RecLDocDim."Dimension Value Code" := '19.20112';
                            RecLDocDim.Insert(true);
                        end;

                        if RecLDocDim.Get(39, RecLPurchLine."Document Type", RecLPurchLine."Document No.", RecLPurchLine."Line No.",
                                'PROFIT') then begin
                            RecLDocDim."Dimension Value Code" := '19.10003';
                            RecLDocDim.Modify(true);
                        end else begin
                            RecLDocDim.Init;
                            RecLDocDim."Table ID" := 39;
                            RecLDocDim."Document Type" := RecLPurchLine."Document Type";
                            RecLDocDim."Document No." := RecLPurchLine."Document No.";
                            RecLDocDim."Line No." := RecLPurchLine."Line No.";
                            RecLDocDim."Dimension Code" := 'PROFIT';
                            RecLDocDim."Dimension Value Code" := '19.10003';
                            RecLDocDim.Insert(true);
                        end;

                    until RecLPurchLine.Next = 0;
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

