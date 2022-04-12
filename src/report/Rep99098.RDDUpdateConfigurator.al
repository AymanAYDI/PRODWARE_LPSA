report 99098 "PWD RDD - Update Configurator"
{
    // //Temportaire : uniquement pour demarrage et initialiser le configurateur article.
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/RDDUpdateConfigurator.rdl';


    dataset
    {
        dataitem("PWD Item Configurator"; "PWD Item Configurator")
        {

            trigger OnAfterGetRecord()
            var
                RecLItem: Record Item;
                RecLDefDim: Record "Default Dimension";
                RecL50005: Record "PWD Piece Type";
            begin
                RecLItem.Reset;
                if RecLItem.Get("PWD Item Configurator"."Item Code") then begin
                    case RecLItem."Item Category Code" of
                        'ACI':
                            begin
                            end;
                        'ELI':
                            begin
                                "PWD Item Configurator"."Product Type" := "PWD Item Configurator"."Product Type"::"LIFTED AND ELLIPSES"
                            end;
                        'LEV':
                            begin
                                "PWD Item Configurator"."Product Type" := "PWD Item Configurator"."Product Type"::"LIFTED AND ELLIPSES"
                            end;
                        'PIE':
                            begin
                                "PWD Item Configurator"."Product Type" := "PWD Item Configurator"."Product Type"::STONE
                            end;
                        'PRE':
                            begin
                                "PWD Item Configurator"."Product Type" := "PWD Item Configurator"."Product Type"::PREPARAGE
                            end;
                    end;
                    RecLDefDim.Reset;
                    if RecLDefDim.Get(DATABASE::Item, "PWD Item Configurator"."Item Code", 'COUT') then
                        "PWD Item Configurator"."Dimension 1 Code" := RecLDefDim."Dimension Value Code";
                    RecLDefDim.Reset;
                    if RecLDefDim.Get(DATABASE::Item, "PWD Item Configurator"."Item Code", 'PROFIT') then
                        "PWD Item Configurator"."Dimension 2 Code" := RecLDefDim."Dimension Value Code";
                    RecLDefDim.Reset;
                    if RecLDefDim.Get(DATABASE::Item, "PWD Item Configurator"."Item Code", 'ARTICLE_ROLEX') then
                        "PWD Item Configurator"."Dimension 3 Code" := RecLDefDim."Dimension Value Code";
                    "PWD Item Configurator"."Location Code" := RecLItem."Location Code";
                    "PWD Item Configurator"."Bin Code" := RecLItem."Shelf No.";
                    "PWD Item Configurator"."Item Category Code" := RecLItem."Item Category Code";
                    "PWD Item Configurator"."Product Group Code" := RecLItem."Product Group Code";
                    "PWD Item Configurator"."PWD LPSA Description 1" := RecLItem."PWD LPSA Description 1";
                    "PWD Item Configurator"."PWD LPSA Description 2" := RecLItem."PWD LPSA Description 2";
                    "PWD Item Configurator"."PWD Quartis Description" := RecLItem."PWD Quartis Description";
                    //  RecL50005.RESET;
                    //  RecL50005.SETRANGE(Code,
                    "PWD Item Configurator".Modify;
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
}

