report 50029 "Create Item Config. from Item"
{
    // //>>LAP2.12
    // P19646_010 : RO : 12/09/2017 :  CONFIGURATEUR ARTICLE
    //                - new report
    // 
    // TDL21072020.001 : 21/07/2020 : Modification création des axes

    Caption = 'Create Item Config. from Item';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "Location Code", "No.";

            trigger OnAfterGetRecord()
            var
                RecLInventorySetup: Record "Inventory Setup";
                RecLItemCrossReference: Record "Item Cross Reference";
                BooLCreateItemCrossRef: Boolean;
                CodLFilter: Code[250];
                IntLPipePosition: Integer;
                IntLStringLenght: Integer;
                CodLFilterToCompare: Code[20];
                IntLLoop: Integer;
                RecLDefaultDimension: Record "Default Dimension";
            begin
                BDialog.Update(1, IntGCounter);
                IntGCounter -= 1;

                RecGItemConfigurator.Reset();
                RecGItemConfigurator.SetCurrentKey("Item Code");
                RecGItemConfigurator.SetRange("Item Code", Item."No.");
                if RecGItemConfigurator.FindFirst() then
                    CurrReport.Skip();

                RecGItemConfigurator.Init();
                RecGItemConfigurator.Insert(true);
                if RecGFamilyLPSA.Get(CopyStr(Item."No.", 1, 2)) then
                    RecGItemConfigurator."Family Code" := CopyStr(Item."No.", 1, 2);
                if RecGSubFamilyLPSA.Get(CopyStr(Item."No.", 1, 2), CopyStr(Item."No.", 3, 2)) then
                    RecGItemConfigurator."Subfamily Code" := CopyStr(Item."No.", 3, 2);
                RecGItemConfigurator."PWD LPSA Description 1" := Item."PWD LPSA Description 1";
                RecGItemConfigurator."PWD LPSA Description 2" := Item."PWD LPSA Description 2";
                RecGItemConfigurator."PWD Quartis Description" := Item."PWD Quartis Description";
                RecGItemConfigurator."Location Code" := Item."Location Code";
                RecGItemConfigurator."Bin Code" := Item."Shelf No.";
                RecGItemConfigurator.Validate("Item Category Code", Item."Item Category Code");
                                //TODO:Field 'Product Group Code' is removed.
                //RecGItemConfigurator."Product Group Code" := Item."Product Group Code";
                RecGItemConfigurator."Dimension 1 Code" := Item."Global Dimension 1 Code";
                RecGItemConfigurator."Dimension 2 Code" := Item."Global Dimension 2 Code";
                RecGItemConfigurator."Phantom Item" := Item."PWD Phantom Item";
                RecGItemConfigurator."Create From Item" := true;
                RecGItemConfigurator."Item Code" := Item."No.";
                RecGItemConfigurator.Modify();

                RecLInventorySetup.Get();
                RecLInventorySetup.TestField("PWD Product Group Code Dim");
                //TODO:Field 'Product Group Code' is removed.
                if "Product Group Code" <> '' then
                    if RecLDefaultDimension.Get(DATABASE::Item, Item."No.", RecLInventorySetup."PWD Product Group Code Dim") then begin
                        RecLDefaultDimension."Dimension Value Code" := "Product Group Code";
                        //RecLDefaultDimension."Dimension Value Code" := "Item Category Code"+'_'+"Product Group Code"; //TDL21072020.001

                        RecLDefaultDimension.Modify();
                    end else begin
                        RecLDefaultDimension."Table ID" := DATABASE::Item;
                        RecLDefaultDimension."No." := Item."No.";
                        RecLDefaultDimension."Dimension Code" := RecLInventorySetup."PWD Product Group Code Dim";
                        //TODO:Field 'Product Group Code' is removed.
                        //RecLDefaultDimension."Dimension Value Code" := "Product Group Code";
                        //RecLDefaultDimension."Dimension Value Code" := "Item Category Code"+'_'+"Product Group Code"; //TDL21072020.001
                        RecLDefaultDimension.Insert();
                    end;

                BooLCreateItemCrossRef := false;

                RecLInventorySetup.TestField("PWD Item Filter For Extern Ref");
                RecLInventorySetup.TestField("PWD LPSA Customer No.");
                //RecLInventorySetup.TESTFIELD("STRATEGY Customer No.");

                CodLFilter := RecLInventorySetup."PWD Item Filter For Extern Ref";
                IntLLoop := 0;

                repeat
                    IntLLoop += 1;
                    IntLPipePosition := StrPos(CodLFilter, '|');
                    if IntLPipePosition <> 0 then
                        CodLFilterToCompare := CopyStr(CodLFilter, 1, IntLPipePosition - 1)
                    else
                        CodLFilterToCompare := CodLFilter;

                    CodLFilterToCompare := DelChr(CodLFilterToCompare, '<>', '*');
                    IntLStringLenght := StrLen(CodLFilterToCompare);

                    if CodLFilterToCompare = CopyStr(Item."No.", 1, IntLStringLenght) then
                        BooLCreateItemCrossRef := true;

                    CodLFilter := CopyStr(CodLFilter, IntLPipePosition + 1);

                until (IntLPipePosition = 0) or (BooLCreateItemCrossRef) or (IntLLoop > 200);

                if BooLCreateItemCrossRef then begin
                    if RecLInventorySetup."PWD STRATEGY Customer No." <> '' then
                        if not RecLItemCrossReference.Get(Item."No.",
                                                          '',
                                                          Item."Base Unit of Measure",
                                                          RecLItemCrossReference."Cross-Reference Type"::Customer,
                                                          RecLInventorySetup."PWD STRATEGY Customer No.",
                                                          'NC') then begin
                            RecLItemCrossReference.Init();
                            RecLItemCrossReference.Validate("Item No.", Item."No.");
                            RecLItemCrossReference.Validate("Unit of Measure", Item."Base Unit of Measure");
                            RecLItemCrossReference.Validate("Cross-Reference Type", RecLItemCrossReference."Cross-Reference Type"::Customer);
                            RecLItemCrossReference.Validate("Cross-Reference Type No.", RecLInventorySetup."PWD STRATEGY Customer No.");
                            RecLItemCrossReference.Validate("Cross-Reference No.", 'NC');
                            RecLItemCrossReference.Insert();
                        end;
                    if not RecLItemCrossReference.Get(Item."No.",
                                                      '',
                                                      Item."Base Unit of Measure",
                                                      RecLItemCrossReference."Cross-Reference Type"::Customer,
                                                      RecLInventorySetup."PWD LPSA Customer No.",
                                                      'NC') then begin
                        RecLItemCrossReference.Init();
                        RecLItemCrossReference.Validate("Item No.", Item."No.");
                        RecLItemCrossReference.Validate("Unit of Measure", Item."Base Unit of Measure");
                        RecLItemCrossReference.Validate("Cross-Reference Type", RecLItemCrossReference."Cross-Reference Type"::Customer);
                        RecLItemCrossReference.Validate("Cross-Reference Type No.", RecLInventorySetup."PWD LPSA Customer No.");
                        RecLItemCrossReference.Validate("Cross-Reference No.", 'NC');
                        RecLItemCrossReference.Insert();
                    end;
                end;
                //<<LAP2.12
            end;

            trigger OnPostDataItem()
            begin
                BDialog.Close();
                Message('Traitement terminé');
            end;

            trigger OnPreDataItem()
            begin
                if Item.GetFilter("Location Code") = '' then
                    Error(CstG001);
                IntGCounter := Item.Count;
                BDialog.Open('Création de l''Item Configurator à partir de l''article\Enregistrements restants #1#########################');
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
        RecGItemConfigurator: Record "PWD Item Configurator";
        CstG001: Label 'Merci de spécifier un code magasin pour le filtrage';
        RecGFamilyLPSA: Record "PWD Family LPSA";
        RecGSubFamilyLPSA: Record "PWD SubFamily LPSA";
        BDialog: Dialog;
        IntGCounter: Integer;
}

