codeunit 50001 "PWD Item Configurator"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                                         |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART01.001: TO 07/12/2011:  Configurateur article
    //                                           - Create CU
    // 
    // //>>LAP2.02
    // FE_LAPIERRETTE_ART01.002: GR 15/06/2012:  Configurateur article  (PT TDL 34)
    //                                           Add Function to update Item Description
    //                                            FctUpdteDescription
    //                                            FctBuildDescription
    //                                           Modify function
    //                                            FctConfigDescStone
    // 
    // //>>LAP2.03
    // FE_LAPIERRETTE_ART01.003: TO 10/09/2012:  Configurateur article  (PT TDL 58)
    //                                           Add Function FctBuildDescriptionQ for Quartis Description
    //                                           Modify functions FctConfigDescStone, FctConfigDescPrepa, FctConfigDescLifted
    // 
    // //>>LAP2.04
    // FE_LAPIERRETTE_ART01.004: TO 24/09/2012:  Configurateur article  (PT TDL 58)
    //                                           Modify Function FctBuildDescriptionQ for Quartis Description
    // 
    // //>>LAP2.04
    // FE_LAPIERRETTE_ART01.005: LY 23/09/2013:  Configurateur article  (PT TDL 58)
    //                                           Delete Space in Quartis Description
    // 
    // TDL.LPSA.20.04.15:APA 20/04/15: - Modify Function FctConfigDescSemiFinish
    // //>>LAP090615
    // TO 09/06/2015: Add new rule 513*
    // 
    // //>>NDBI
    // P27818_002 : LALE.PA : 02/03/2021 : cf. demande mail client TI528225
    //                   - Modif C/AL Code in trigger FctConfigDescStone
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    begin
        //ItemConf.GET(2620);
        //BuildQuartisDesc(ItemConf);
    end;


    procedure FctConfigDescStone(var RecPItemConfigurator: Record "PWD Item Configurator")
    var
        Longueur: Integer;
        TxtLDim1: Text[30];
        TxtLDim2: Text[30];
    begin
        if RecPItemConfigurator."Matter Stone" <> '' then
            RecPItemConfigurator."PWD LPSA Description 1" := CopyStr(RecPItemConfigurator."Matter Stone", 1, 1) + LowerCase(CopyStr(RecPItemConfigurator."Matter Stone", 2, StrLen(RecPItemConfigurator."Matter Stone") - 1))
        else
            RecPItemConfigurator."PWD LPSA Description 1" := '';
        RecPItemConfigurator."PWD LPSA Description 1" += Format(RecPItemConfigurator.Number) + RecPItemConfigurator.Orientation + '-' + RecPItemConfigurator."Piece Type Stone";

        Longueur := StrLen(RecPItemConfigurator."PWD LPSA Description 1") - StrLen(RecPItemConfigurator."Piece Type Stone") + 1;

        RecPItemConfigurator."PWD LPSA Description 2" := '';

        if RecPItemConfigurator.Hole <> 0 then
            if RecPItemConfigurator."Hole Min." = -RecPItemConfigurator."Hole Max." then
                RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '-T' + Format(RecPItemConfigurator.Hole) + '(+/-' + Format(RecPItemConfigurator."Hole Max.") + ')'
            else
                RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", '-T', RecPItemConfigurator.Hole, RecPItemConfigurator."Hole Min.", RecPItemConfigurator."Hole Max.");

        //>>NDBI
        /*
          IF "External Diameter" <> 0 THEN
            IF "External Diameter Min." = -"External Diameter Max." THEN
               "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xD' + FORMAT("External Diameter") + '(+/-' +
                                                                      FORMAT("External Diameter Max.") + ')'
            ELSE
               "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1",'xD',"External Diameter","External Diameter Min.",
                                                           "External Diameter Max.");

          IF Thickness <> 0 THEN
            IF "Thickness Min." = -"Thickness Max." THEN
              "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xE' + FORMAT(Thickness) + '(+/-' + FORMAT("Thickness Max.") + ')'
            ELSE
              "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1",'xE',Thickness,"Thickness Min.","Thickness Max.");
        */
        if (RecPItemConfigurator.Hole = 0) then begin
            if RecPItemConfigurator."External Diameter" <> 0 then
                if RecPItemConfigurator."External Diameter Min." = -RecPItemConfigurator."External Diameter Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '-D' + Format(RecPItemConfigurator."External Diameter") + '(+/-' +
                                                                           Format(RecPItemConfigurator."External Diameter Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", '-D', RecPItemConfigurator."External Diameter", RecPItemConfigurator."External Diameter Min.",
                                                                RecPItemConfigurator."External Diameter Max.");
        end else
            if RecPItemConfigurator."External Diameter" <> 0 then
                if RecPItemConfigurator."External Diameter Min." = -RecPItemConfigurator."External Diameter Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xD' + Format(RecPItemConfigurator."External Diameter") + '(+/-' +
                                                                           Format(RecPItemConfigurator."External Diameter Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'xD', RecPItemConfigurator."External Diameter", RecPItemConfigurator."External Diameter Min.",
                                                                RecPItemConfigurator."External Diameter Max.");
        if (RecPItemConfigurator.Hole = 0) and (RecPItemConfigurator."External Diameter" = 0) then begin
            if RecPItemConfigurator.Thickness <> 0 then
                if RecPItemConfigurator."Thickness Min." = -RecPItemConfigurator."Thickness Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '-E' + Format(RecPItemConfigurator.Thickness) + '(+/-' + Format(RecPItemConfigurator."Thickness Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", '-E', RecPItemConfigurator.Thickness, RecPItemConfigurator."Thickness Min.", RecPItemConfigurator."Thickness Max.");
        end else
            if RecPItemConfigurator.Thickness <> 0 then
                if RecPItemConfigurator."Thickness Min." = -RecPItemConfigurator."Thickness Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xE' + Format(RecPItemConfigurator.Thickness) + '(+/-' + Format(RecPItemConfigurator."Thickness Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'xE', RecPItemConfigurator.Thickness, RecPItemConfigurator."Thickness Min.", RecPItemConfigurator."Thickness Max.");
        //>>NDBI

        if RecPItemConfigurator."Recess Diametre" <> 0 then
            if RecPItemConfigurator."Recess Diametre Min." = -RecPItemConfigurator."Recess Diametre Max." then
                RecPItemConfigurator."PWD LPSA Description 2" := 'C' + Format(RecPItemConfigurator."Recess Diametre") + '(+/-' + Format(RecPItemConfigurator."Recess Diametre Max.") + ')'
            else
                if RecPItemConfigurator."Recess Diametre Min." < 0 then
                    RecPItemConfigurator."PWD LPSA Description 2" := 'C' + Format(RecPItemConfigurator."Recess Diametre") + '(' + Format(RecPItemConfigurator."Recess Diametre Min.") + '/+' +
                                                  Format(RecPItemConfigurator."Recess Diametre Max.") + ')'

                else
                    RecPItemConfigurator."PWD LPSA Description 2" := 'C' + Format(RecPItemConfigurator."Recess Diametre") + '(+' + Format(RecPItemConfigurator."Recess Diametre Min.") + '/+' +
                                                  Format(RecPItemConfigurator."Recess Diametre Max.") + ')';


        if RecPItemConfigurator."Hole Length" <> 0 then
            if RecPItemConfigurator."Hole Length Min." = -RecPItemConfigurator."Hole Length Max." then
                RecPItemConfigurator."PWD LPSA Description 2" := RecPItemConfigurator."PWD LPSA Description 2" + 'xL' + Format(RecPItemConfigurator."Hole Length") + '(+/-' + Format(RecPItemConfigurator."Hole Length Max.") + ')'
            else
                RecPItemConfigurator."PWD LPSA Description 2" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 2", 'xL', RecPItemConfigurator."Hole Length", RecPItemConfigurator."Hole Length Min.", RecPItemConfigurator."Hole Length Max.");


        if RecPItemConfigurator."Height Band" <> 0 then
            if RecPItemConfigurator."Height Band Min." = -RecPItemConfigurator."Height Band Max." then
                RecPItemConfigurator."PWD LPSA Description 2" := RecPItemConfigurator."PWD LPSA Description 2" + 'xR' + Format(RecPItemConfigurator."Height Band") + '(+/-' + Format(RecPItemConfigurator."Height Band Max.") + ')'
            else
                RecPItemConfigurator."PWD LPSA Description 2" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 2", 'xR', RecPItemConfigurator."Height Band", RecPItemConfigurator."Height Band Min.", RecPItemConfigurator."Height Band Max.");

        if RecPItemConfigurator."Height Cambered" <> 0 then
            if RecPItemConfigurator."Height Cambered Min." = -RecPItemConfigurator."Height Cambered Max." then
                RecPItemConfigurator."PWD LPSA Description 2" := RecPItemConfigurator."PWD LPSA Description 2" + 'xB' + Format(RecPItemConfigurator."Height Cambered") +
                                       '(+/-' + Format(RecPItemConfigurator."Height Cambered Max.") + ')'
            else
                RecPItemConfigurator."PWD LPSA Description 2" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 2", 'xB', RecPItemConfigurator."Height Cambered", RecPItemConfigurator."Height Cambered Min.",
                                                            RecPItemConfigurator."Height Cambered Max.");


        if RecPItemConfigurator."Height Half Glazed" <> 0 then
            if RecPItemConfigurator."Height Half Glazed Min." = -RecPItemConfigurator."Height Half Glazed Max." then
                RecPItemConfigurator."PWD LPSA Description 2" := RecPItemConfigurator."PWD LPSA Description 2" + 'xG' + Format(RecPItemConfigurator."Height Half Glazed") + '(+/-' +
                                         Format(RecPItemConfigurator."Height Half Glazed Max.") + ')'
            else
                RecPItemConfigurator."PWD LPSA Description 2" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 2", 'xG', RecPItemConfigurator."Height Half Glazed", RecPItemConfigurator."Height Half Glazed Min.",
                                                            RecPItemConfigurator."Height Half Glazed Max.");


        TxtLDim1 := Format(RecPItemConfigurator.Hole);
        TxtLDim2 := Format(RecPItemConfigurator."External Diameter");

        if StrPos(TxtLDim1, ',') > 0 then
            TxtLDim1 := CopyStr(TxtLDim1, 1, StrPos(TxtLDim1, ',') + 1);
        if StrPos(TxtLDim2, ',') > 0 then
            TxtLDim2 := CopyStr(TxtLDim2, 1, StrPos(TxtLDim2, ',') + 1);

        RecPItemConfigurator."PWD Quartis Description" := CopyStr(RecPItemConfigurator."PWD LPSA Description 1", Longueur, 40);

        //>>CSC
        RecPItemConfigurator."Quartis Desc TEST" := BuildQuartisDesc(RecPItemConfigurator);
        //<<CSC

        //>>TDL.LPSA.20.04.15
        //IF ((RecPItemConfigurator."Location Code" = 'PIE') AND
        //>>LPA090615
        //     ((COPYSTR(RecPItemConfigurator."Item Code",1,3) = '802') OR (COPYSTR(RecPItemConfigurator."Item Code",1,3) = '992'))) THEN
        //       ((COPYSTR(RecPItemConfigurator."Item Code",1,3) = '802') OR (COPYSTR(RecPItemConfigurator."Item Code",1,3) = '992') OR
        //        (COPYSTR(RecPItemConfigurator."Item Code",1,3) = '513'))) THEN
        //<<LP090615
        //  "PWD Quartis Description" :=  COPYSTR("Piece Type Stone" + '-' + "PWD Quartis Description",1,40);
        //<<TDL.LPSA.20.04.15

        FctUpdteDescription(RecPItemConfigurator);

    end;


    procedure FctConfigDescPrepa(var RecPItemConfigurator: Record "PWD Item Configurator")
    var
        TxtLQuartisDesc: Text[120];
    begin
        if RecPItemConfigurator."Matter Preparage" <> '' then
            RecPItemConfigurator."PWD LPSA Description 1" := CopyStr(RecPItemConfigurator."Matter Preparage", 1, 1) + LowerCase(CopyStr(RecPItemConfigurator."Matter Preparage", 2, StrLen(RecPItemConfigurator."Matter Preparage") - 1))
        else
            RecPItemConfigurator."PWD LPSA Description 1" := '';
        RecPItemConfigurator."PWD LPSA Description 1" += Format(RecPItemConfigurator.Number) + RecPItemConfigurator.Orientation + '-' + RecPItemConfigurator."Piece Type Preparage";

        //>>TDL.LPSA.20.04.15
        //"PWD Quartis Description" := "Piece Type Preparage" + '-';
        //IF (RecPItemConfigurator."Location Code" = 'PIE') AND
        //>>LPA090615
        //    (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992') THEN
        //      (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992')
        //      AND  (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '513') THEN
        //<<LPA090615
        //   "PWD Quartis Description" := ''
        // ELSE
        RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."Piece Type Preparage" + '-';
        //<<TDL.LPSA.20.04.15
        // 20200615-ANF modification ordre de designation ENTRETOISE

        if RecPItemConfigurator."Piece Type Preparage" in ['CARRELET', 'ENTRETOISE'] then begin
            if ((RecPItemConfigurator."Width / Depth Min." <> 0) or (RecPItemConfigurator."Width / Depth Max." <> 0)) then
                if RecPItemConfigurator."Width / Depth Min." = -RecPItemConfigurator."Width / Depth Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '-L' + '+/-' + Format(RecPItemConfigurator."Width / Depth Max.")
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", '-L', RecPItemConfigurator."Width / Depth Min.", RecPItemConfigurator."Width / Depth Max.");

            if ((RecPItemConfigurator."Thick Min." <> 0) or (RecPItemConfigurator."Thick Max." <> 0)) then
                if RecPItemConfigurator."Thick Min." = -RecPItemConfigurator."Thickness Min." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xE' + '+/-' + Format(RecPItemConfigurator."Thick Min.")
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", 'xE', RecPItemConfigurator."Thick Min.", RecPItemConfigurator."Thick Max.");


            if ((RecPItemConfigurator."Height Min." <> 0) or (RecPItemConfigurator."Height Max." <> 0)) then
                if RecPItemConfigurator."Height Min." = -RecPItemConfigurator."Height Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xH' + '+/-' + Format(RecPItemConfigurator."Height Max.")
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", 'xH', RecPItemConfigurator."Height Min.", RecPItemConfigurator."Height Max.");



            if ((RecPItemConfigurator."Width Min." <> 0) or (RecPItemConfigurator."Width Max." <> 0)) then
                if RecPItemConfigurator."Width Min." = -RecPItemConfigurator."Width Max." then begin
                    TxtLQuartisDesc := RecPItemConfigurator."PWD Quartis Description" + 'L' + '-/+' + Format(RecPItemConfigurator."Width Max.");
                    RecPItemConfigurator."PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                end
                else
                    RecPItemConfigurator."PWD Quartis Description" := FctBuildDescriptionQ2(RecPItemConfigurator."PWD Quartis Description", 'L', RecPItemConfigurator."Width Min.", RecPItemConfigurator."Width Max.");

            if ((RecPItemConfigurator."Height Min." <> 0) or (RecPItemConfigurator."Height Max." <> 0)) then
                if RecPItemConfigurator."Height Min." = -RecPItemConfigurator."Height Max." then begin
                    TxtLQuartisDesc := RecPItemConfigurator."PWD Quartis Description" + 'H' + '+/-' + Format(RecPItemConfigurator."Height Max.");
                    RecPItemConfigurator."PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                end
                else
                    RecPItemConfigurator."PWD Quartis Description" := FctBuildDescriptionQ2(RecPItemConfigurator."PWD Quartis Description", 'xH', RecPItemConfigurator."Height Min.", RecPItemConfigurator."Height Max.");

            if ((RecPItemConfigurator."Width / Depth Min." <> 0) or (RecPItemConfigurator."Width / Depth Max." <> 0)) then
                if RecPItemConfigurator."Width / Depth Min." = -RecPItemConfigurator."Width / Depth Max." then begin
                    TxtLQuartisDesc := RecPItemConfigurator."PWD Quartis Description" + 'P' + '+/-' + Format(RecPItemConfigurator."Width / Depth Max.");
                    RecPItemConfigurator."PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                end
                else
                    RecPItemConfigurator."PWD Quartis Description" := FctBuildDescriptionQ2(RecPItemConfigurator."PWD Quartis Description", 'xP', RecPItemConfigurator."Width / Depth Min.", RecPItemConfigurator."Width / Depth Max.");
        end
        else
            if RecPItemConfigurator."Piece Type Preparage" in ['CHEVILLE', 'GOUPILLE'] then begin
                if ((RecPItemConfigurator."Diameter Min." <> 0) or (RecPItemConfigurator."Diameter Max." <> 0)) then
                    if RecPItemConfigurator."Diameter Min." = -RecPItemConfigurator."Diameter Max." then
                        RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '-D' + '+/-' + Format(RecPItemConfigurator."Diameter Max.")
                    else
                        RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", '-D', RecPItemConfigurator."Diameter Min.", RecPItemConfigurator."Diameter Max.");
                if ((RecPItemConfigurator."Width / Depth Min." <> 0) or (RecPItemConfigurator."Width / Depth Min." <> 0)) then
                    if RecPItemConfigurator."Width / Depth Min." = -RecPItemConfigurator."Width / Depth Max." then
                        RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xL' + '+/-' + Format(RecPItemConfigurator."Width / Depth Max.")
                    else
                        RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", 'xL', RecPItemConfigurator."Width / Depth Min.", RecPItemConfigurator."Width / Depth Max.");
                if ((RecPItemConfigurator."Diameter Min." <> 0) or (RecPItemConfigurator."Diameter Max." <> 0)) then
                    if RecPItemConfigurator."Diameter Min." = -RecPItemConfigurator."Diameter Max." then begin
                        TxtLQuartisDesc := RecPItemConfigurator."PWD Quartis Description" + 'D' + '+/-' + Format(RecPItemConfigurator."Diameter Max.");
                        RecPItemConfigurator."PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                    end
                    else
                        RecPItemConfigurator."PWD Quartis Description" := FctBuildDescriptionQ2(RecPItemConfigurator."PWD Quartis Description", 'D', RecPItemConfigurator."Diameter Min.", RecPItemConfigurator."Diameter Max.");

                if ((RecPItemConfigurator."Width / Depth Min." <> 0) or (RecPItemConfigurator."Width / Depth Max." <> 0)) then
                    if RecPItemConfigurator."Width / Depth Min." = -RecPItemConfigurator."Width / Depth Max." then begin
                        TxtLQuartisDesc := RecPItemConfigurator."PWD Quartis Description" + 'xL' + '+/-' + Format(RecPItemConfigurator."Width / Depth Max.");
                        RecPItemConfigurator."PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                    end
                    else
                        RecPItemConfigurator."PWD Quartis Description" := FctBuildDescriptionQ2(RecPItemConfigurator."PWD Quartis Description", 'xL', RecPItemConfigurator."Width / Depth Min.", RecPItemConfigurator."Width / Depth Max.");
            end
            //
            else
                if RecPItemConfigurator."Piece Type Preparage" in ['BARRE', 'C-PIVOT', 'NON PERCE'] then begin
                    if ((RecPItemConfigurator."Diameter Min." <> 0) or (RecPItemConfigurator."Diameter Max." <> 0)) then begin
                        RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", '-D', RecPItemConfigurator."Diameter Min.", RecPItemConfigurator."Diameter Max.");
                        RecPItemConfigurator."PWD Quartis Description" := FctBuildDescriptionQ2(RecPItemConfigurator."PWD Quartis Description", 'D', RecPItemConfigurator."Diameter Min.", RecPItemConfigurator."Diameter Max.");
                    end;
                    if (RecPItemConfigurator."Thick Min." <> 0) or (RecPItemConfigurator."Thick Max." <> 0) then begin
                        RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", 'xE', RecPItemConfigurator."Thick Min.", RecPItemConfigurator."Thick Max.");
                        RecPItemConfigurator."PWD Quartis Description" := FctBuildDescriptionQ2(RecPItemConfigurator."PWD Quartis Description", 'xE', RecPItemConfigurator."Thick Min.", RecPItemConfigurator."Thick Max.");
                    end;
                end
                else begin
                    if ((RecPItemConfigurator."Piercing Min." <> 0) or (RecPItemConfigurator."Piercing Max." <> 0)) then begin
                        RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", '-T', RecPItemConfigurator."Piercing Min.", RecPItemConfigurator."Piercing Max.");
                        RecPItemConfigurator."PWD Quartis Description" := FctBuildDescriptionQ2(RecPItemConfigurator."PWD Quartis Description", 'T', RecPItemConfigurator."Piercing Min.", RecPItemConfigurator."Piercing Max.");
                    end;

                    if RecPItemConfigurator.Note <> 0 then begin
                        RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '(' + Format(RecPItemConfigurator.Note) + ')';
                        TxtLQuartisDesc := RecPItemConfigurator."PWD Quartis Description" + '(' + Format(RecPItemConfigurator.Note) + ')';
                        RecPItemConfigurator."PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                    end;

                    if ((RecPItemConfigurator."Diameter Min." <> 0) or (RecPItemConfigurator."Diameter Max." <> 0)) then
                        if RecPItemConfigurator."Diameter Min." = -RecPItemConfigurator."Diameter Max." then begin
                            RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xD' + '+/-' + Format(RecPItemConfigurator."Diameter Max.");
                            TxtLQuartisDesc := RecPItemConfigurator."PWD Quartis Description" + 'xD' + '+/-' + Format(RecPItemConfigurator."Diameter Max.");
                            RecPItemConfigurator."PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                        end
                        else begin
                            RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", 'xD', RecPItemConfigurator."Diameter Min.", RecPItemConfigurator."Diameter Max.");
                            RecPItemConfigurator."PWD Quartis Description" := FctBuildDescriptionQ2(RecPItemConfigurator."PWD Quartis Description", 'xD', RecPItemConfigurator."Diameter Min.", RecPItemConfigurator."Diameter Max.");
                        end;
                    if (RecPItemConfigurator."Thick Min." <> 0) or (RecPItemConfigurator."Thick Max." <> 0) then
                        if RecPItemConfigurator."Thick Min." = -RecPItemConfigurator."Thick Max." then begin
                            RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xE' + '+/-' + Format(RecPItemConfigurator."Thick Max.");
                            TxtLQuartisDesc := RecPItemConfigurator."PWD Quartis Description" + 'xE' + '+/-' + Format(RecPItemConfigurator."Thick Max.");
                            RecPItemConfigurator."PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                        end
                        else begin
                            RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", 'xE', RecPItemConfigurator."Thick Min.", RecPItemConfigurator."Thick Max.");
                            RecPItemConfigurator."PWD Quartis Description" := FctBuildDescriptionQ2(RecPItemConfigurator."PWD Quartis Description", 'xE', RecPItemConfigurator."Thick Min.", RecPItemConfigurator."Thick Max.");
                        end;
                end;

        RecPItemConfigurator."PWD LPSA Description 2" := '';

        //>>CSC
        RecPItemConfigurator."Quartis Desc TEST" := BuildQuartisDesc(RecPItemConfigurator);
        //<<CSC

        FctUpdteDescription(RecPItemConfigurator);
    end;


    procedure FctConfigDescLifted(var RecPItemConfigurator: Record "PWD Item Configurator")
    var
        TxtLChar: Text[1];
    begin

        RecPItemConfigurator."PWD LPSA Description 2" := '';
        if RecPItemConfigurator."Matter Lifted&Ellipses" <> '' then
            RecPItemConfigurator."PWD LPSA Description 1" := CopyStr(RecPItemConfigurator."Matter Lifted&Ellipses", 1, 1) +
                                    LowerCase(CopyStr(RecPItemConfigurator."Matter Lifted&Ellipses", 2, StrLen(RecPItemConfigurator."Matter Lifted&Ellipses") - 1))
        else
            RecPItemConfigurator."PWD LPSA Description 1" := '';
        RecPItemConfigurator."PWD LPSA Description 1" += Format(RecPItemConfigurator.Number) + RecPItemConfigurator.Orientation + '-' + RecPItemConfigurator."Piece Type Lifted&Ellipses";

        //>>TDL.LPSA.20.04.15
        //"PWD Quartis Description" := "Piece Type Lifted&Ellipses";
        //IF (RecPItemConfigurator."Location Code" = 'PIE') AND
        //>>LPA090615
        //   (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992') THEN
        //   (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992')
        //   AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '513') THEN
        //<<LPA090615
        //   "PWD Quartis Description" := ''
        //ELSE
        RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."Piece Type Lifted&Ellipses";
        //<<TDL.LPSA.20.04.15

        //->> 20200615-ANF modification ordre de designation des LEVEES

        if RecPItemConfigurator."Piece Type Lifted&Ellipses" = 'LEVEES' then begin

            //Inversion L et A
            if (RecPItemConfigurator."Lg Tol" <> 0) then begin
                if RecPItemConfigurator."Lg Tol Min." = -RecPItemConfigurator."Lg Tol Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '-L' + Format(RecPItemConfigurator."Lg Tol") + '(+/-' + Format(RecPItemConfigurator."Lg Tol Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'xL', RecPItemConfigurator."Lg Tol", RecPItemConfigurator."Lg Tol Min.", RecPItemConfigurator."Lg Tol Max.");
                RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + '-L' + Format(RecPItemConfigurator."Lg Tol");
            end;


            if (RecPItemConfigurator."Height Tol" <> 0) then begin
                //IF "Height Min. Tol" = -"Height Max. Tol" THEN
                //  "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xH' + FORMAT("Height Tol") + '(+/-' + FORMAT("Height Max. Tol") + ')'
                //ELSE
                //  "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'xH',"Height Tol","Height Min. Tol","Height Max. Tol");
                //"PWD Quartis Description" := "PWD Quartis Description" + '-H' + FORMAT("Height Tol");
                if CopyStr(RecPItemConfigurator."Item Code", 1, 4) = '9930' then
                    TxtLChar := 'E'
                else
                    TxtLChar := 'H';
                if RecPItemConfigurator."Height Min. Tol" = -RecPItemConfigurator."Height Max. Tol" then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'x' + TxtLChar + Format(RecPItemConfigurator."Height Tol")
                                                + '(+/-' + Format(RecPItemConfigurator."Height Max. Tol") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'x' + TxtLChar, RecPItemConfigurator."Height Tol",
                                                  RecPItemConfigurator."Height Min. Tol", RecPItemConfigurator."Height Max. Tol");
                RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + '-' + TxtLChar + Format(RecPItemConfigurator."Height Tol");
            end;

            if (RecPItemConfigurator."Thick Tol" <> 0) then begin
                //IF "Thick Min. Tol" = -"Thick Max. Tol" THEN
                //  "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xE' + FORMAT("Thick Tol") + '(+/-' + FORMAT("Thick Max. Tol") + ')'
                //ELSE
                //  "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1",'xE',"Thick Tol","Thick Min. Tol","Thick Max. Tol");
                //"PWD Quartis Description" := "PWD Quartis Description" + '-E' + FORMAT("Thick Tol");
                if CopyStr(RecPItemConfigurator."Item Code", 1, 4) = '9930' then
                    TxtLChar := 'H'
                else
                    TxtLChar := 'E';
                if RecPItemConfigurator."Thick Min. Tol" = -RecPItemConfigurator."Thick Max. Tol" then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'x' + TxtLChar + Format(RecPItemConfigurator."Thick Tol")
                                               + '(+/-' + Format(RecPItemConfigurator."Thick Max. Tol") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'x' + TxtLChar, RecPItemConfigurator."Thick Tol",
                                                RecPItemConfigurator."Thick Min. Tol", RecPItemConfigurator."Thick Max. Tol");
                RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + '-' + TxtLChar + Format(RecPItemConfigurator."Thick Tol");

            end;

            if (RecPItemConfigurator.Angle <> 0) then begin
                if RecPItemConfigurator."Angle Min." = -RecPItemConfigurator."Angle Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xA' + Format(RecPItemConfigurator.Angle) + '(+/-' + Format(RecPItemConfigurator."Angle Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", '-A', RecPItemConfigurator.Angle, RecPItemConfigurator."Angle Min.", RecPItemConfigurator."Angle Max.");
                RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + 'xA' + Format(RecPItemConfigurator.Angle);
            end;

            //<<- 20200615-ANF modification ordre de designation des LEVEES


        end
        else
            if RecPItemConfigurator."Piece Type Lifted&Ellipses" in ['ELLIPSES', 'PLAT POLI'] then begin
                if (RecPItemConfigurator."Diameter Tol" <> 0) then begin
                    if RecPItemConfigurator."Diameter Tol Min." = -RecPItemConfigurator."Diameter Tol Max." then
                        RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '-D' + Format(RecPItemConfigurator."Diameter Tol") + '(+/-' + Format(RecPItemConfigurator."Diameter Tol Max.") + ')'
                    else
                        RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", '-D', RecPItemConfigurator."Diameter Tol", RecPItemConfigurator."Diameter Tol Min.",
                                                                     RecPItemConfigurator."Diameter Tol Max.");
                    RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + '-D' + Format(RecPItemConfigurator."Diameter Tol");
                end;


                if (RecPItemConfigurator."Thick Tol" <> 0) then begin
                    if RecPItemConfigurator."Thick Min. Tol" = -RecPItemConfigurator."Thick Max. Tol" then
                        RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xP' + Format(RecPItemConfigurator."Thick Tol") + '(+/-' + Format(RecPItemConfigurator."Thick Max. Tol") + ')'
                    else
                        RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'xP', RecPItemConfigurator."Thick Tol", RecPItemConfigurator."Thick Min. Tol", RecPItemConfigurator."Thick Max. Tol");
                    RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + '-P' + Format(RecPItemConfigurator."Thick Tol");
                end;


                if (RecPItemConfigurator."Lg Tol" <> 0) then begin
                    if RecPItemConfigurator."Lg Tol Min." = -RecPItemConfigurator."Lg Tol Max." then
                        RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xL' + Format(RecPItemConfigurator."Lg Tol") + '(+/-' + Format(RecPItemConfigurator."Lg Tol Max.") + ')'
                    else
                        RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'xL', RecPItemConfigurator."Lg Tol", RecPItemConfigurator."Lg Tol Min.", RecPItemConfigurator."Lg Tol Max.");
                    RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + '-L' + Format(RecPItemConfigurator."Lg Tol");
                end;

                if RecPItemConfigurator."Piece Type Lifted&Ellipses" = 'ELLIPSES' then
                    RecPItemConfigurator."PWD LPSA Description 2" := 'xRA' + Format(RecPItemConfigurator."R / Arc") + 'xRC' + Format(RecPItemConfigurator."R / Corde");

            end
            else
                if RecPItemConfigurator."Piece Type Lifted&Ellipses" in ['GOUPILLE', 'CHEVILLE'] then begin
                    if (RecPItemConfigurator."Diameter Tol" <> 0) then begin
                        if RecPItemConfigurator."Diameter Tol Min." = -RecPItemConfigurator."Diameter Tol Max." then
                            RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '-D' + Format(RecPItemConfigurator."Diameter Tol") + '(+/-' + Format(RecPItemConfigurator."Diameter Tol Max.") + ')'
                        else
                            RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", '-D', RecPItemConfigurator."Diameter Tol", RecPItemConfigurator."Diameter Tol Min.",
                                                                        RecPItemConfigurator."Diameter Tol Max.");
                        RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + '-D' + Format(RecPItemConfigurator."Diameter Tol");
                    end;
                    if (RecPItemConfigurator."Lg Tol" <> 0) then begin
                        if RecPItemConfigurator."Lg Tol Min." = -RecPItemConfigurator."Lg Tol Max." then
                            RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xL' + Format(RecPItemConfigurator."Lg Tol") + '(+/-' + Format(RecPItemConfigurator."Lg Tol Max.") + ')'
                        else
                            RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'xL', RecPItemConfigurator."Lg Tol", RecPItemConfigurator."Lg Tol Min.", RecPItemConfigurator."Lg Tol Max.");
                        RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + '-L' + Format(RecPItemConfigurator."Lg Tol");
                    end;
                end
                else begin
                    if (RecPItemConfigurator."Thick Tol" <> 0) then begin
                        //20200615 ANF inversion designation POLI4FACES 5211                    
                        //IF "Thick Min. Tol" = -"Thick Max. Tol" THEN
                        //  "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xL' + FORMAT("Thick Tol") + '(+/-' + FORMAT("Thick Max. Tol") + ')'
                        //ELSE
                        //  "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1",'xL',"Thick Tol","Thick Min. Tol","Thick Max. Tol");
                        //"PWD Quartis Description" := "PWD Quartis Description" + '-L' + FORMAT("Thick Tol");
                        if CopyStr(RecPItemConfigurator."Item Code", 1, 4) = '5211' then
                            TxtLChar := 'L'
                        else
                            TxtLChar := 'P';
                        if RecPItemConfigurator."Lg Tol Min." = -RecPItemConfigurator."Lg Tol Max." then
                            RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '-' + TxtLChar + Format(RecPItemConfigurator."Lg Tol")
                                                     + '(+/-' + Format(RecPItemConfigurator."Lg Tol Max.") + ')'
                        else
                            RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'x' + TxtLChar, RecPItemConfigurator."Lg Tol",
                                                      RecPItemConfigurator."Lg Tol Min.", RecPItemConfigurator."Lg Tol Max.");
                        RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + '-' + TxtLChar + Format(RecPItemConfigurator."Lg Tol");

                    end;


                    if (RecPItemConfigurator."Height Tol" <> 0) then begin
                        //IF "Height Min. Tol" = -"Height Max. Tol" THEN
                        //  "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xH' + FORMAT("Height Tol") + '(+/-' +  FORMAT("Height Max. Tol") + ')'
                        //ELSE
                        //  "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1",'xH',"Height Tol","Height Min. Tol","Height Max. Tol");
                        // "PWD Quartis Description" := "PWD Quartis Description" + '-H' + FORMAT("Height Tol");
                        if CopyStr(RecPItemConfigurator."Item Code", 1, 4) = '5211' then
                            TxtLChar := 'E'
                        else
                            TxtLChar := 'H';
                        if RecPItemConfigurator."Height Min. Tol" = -RecPItemConfigurator."Height Max. Tol" then
                            RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'x' + TxtLChar + Format(RecPItemConfigurator."Height Tol")
                                                       + '(+/-' + Format(RecPItemConfigurator."Height Max. Tol") + ')'
                        else
                            RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'x' + TxtLChar, RecPItemConfigurator."Height Tol",
                                                  RecPItemConfigurator."Height Min. Tol", RecPItemConfigurator."Height Max. Tol");
                        RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + '-' + TxtLChar + Format(RecPItemConfigurator."Height Tol");

                    end;

                    if (RecPItemConfigurator."Lg Tol" <> 0) then begin
                        //IF "Lg Tol Min." = -"Lg Tol Max." THEN
                        //  "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xP' + FORMAT("Lg Tol") + '(+/-' + FORMAT("Lg Tol Max.") + ')'
                        //ELSE
                        //  "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'xP',"Lg Tol","Lg Tol Min.","Lg Tol Max.");
                        //"PWD Quartis Description" := "PWD Quartis Description" + '-P' + FORMAT("Lg Tol");

                        //20200615 ANF Inversion designation POLI4FACES 5211
                        if CopyStr(RecPItemConfigurator."Item Code", 1, 4) = '5211' then
                            TxtLChar := 'H'
                        else
                            TxtLChar := 'L';
                        if RecPItemConfigurator."Thick Min. Tol" = -RecPItemConfigurator."Thick Max. Tol" then
                            RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'x' + TxtLChar + Format(RecPItemConfigurator."Thick Tol")
                                                         + '(+/-' + Format(RecPItemConfigurator."Thick Max. Tol") + ')'
                        else
                            RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'x' + TxtLChar, RecPItemConfigurator."Thick Tol",
                                                    RecPItemConfigurator."Thick Min. Tol", RecPItemConfigurator."Thick Max. Tol");
                        RecPItemConfigurator."PWD Quartis Description" := RecPItemConfigurator."PWD Quartis Description" + '-' + TxtLChar + Format(RecPItemConfigurator."Thick Tol");

                    end;

                    //20200615 ANF Inversion designation POLI4FACES 5211

                end;

        //>>CSC
        RecPItemConfigurator."Quartis Desc TEST" := BuildQuartisDesc(RecPItemConfigurator);
        //<<CSC

        FctUpdteDescription(RecPItemConfigurator);
    end;


    procedure FctConfigDescSemiFinish(var RecPItemConfigurator: Record "PWD Item Configurator")
    var
        TxtLDim1: Text[30];
        Quartis: Text[120];
    begin
        RecPItemConfigurator."PWD LPSA Description 2" := '';
        if RecPItemConfigurator."Matter Semi-finished" <> '' then
            RecPItemConfigurator."PWD LPSA Description 1" := CopyStr(RecPItemConfigurator."Matter Semi-finished", 1, 1) +
                                    LowerCase(CopyStr(RecPItemConfigurator."Matter Semi-finished", 2, StrLen(RecPItemConfigurator."Matter Semi-finished") - 1))
        else
            RecPItemConfigurator."PWD LPSA Description 1" := '';
        RecPItemConfigurator."PWD LPSA Description 1" += Format(RecPItemConfigurator.Number) + RecPItemConfigurator.Orientation + '-' + RecPItemConfigurator."Piece Type Semi-finished";

        if RecPItemConfigurator."Piece Type Semi-finished" = 'GRANDI' then begin
            if RecPItemConfigurator."Hole Tol" <> 0 then
                if RecPItemConfigurator."Hole Tol Min." = -RecPItemConfigurator."Hole Tol Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '-T' + Format(RecPItemConfigurator."Hole Tol") + '(+/-' + Format(RecPItemConfigurator."Hole Tol Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", '-T', RecPItemConfigurator."Hole Tol", RecPItemConfigurator."Hole Tol Min.", RecPItemConfigurator."Hole Tol Max.");

            if ((RecPItemConfigurator."D Min." <> 0) or (RecPItemConfigurator."D Max." <> 0)) then
                if RecPItemConfigurator."D Min." = -RecPItemConfigurator."D Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xD' + '(+/-' + Format(RecPItemConfigurator."D Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", 'xD', RecPItemConfigurator."D Min.", RecPItemConfigurator."D Max.");

            if ((RecPItemConfigurator."Ep Min." <> 0) or (RecPItemConfigurator."Ep Max." <> 0)) then
                if RecPItemConfigurator."Ep Min." = -RecPItemConfigurator."Ep Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xE' + '(+/-' + Format(RecPItemConfigurator."Ep Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", 'xE', RecPItemConfigurator."Ep Min.", RecPItemConfigurator."Ep Max.");

            TxtLDim1 := Format(RecPItemConfigurator."Hole Tol");
            TxtLDim1 := CopyStr(TxtLDim1, 1, StrPos(TxtLDim1, ',') + 1);
            if (RecPItemConfigurator."Hole Tol Min." = -RecPItemConfigurator."Hole Tol Max.") then begin
                //>>TDL.LPSA.20.04.15
                //IF (RecPItemConfigurator."Location Code" = 'PIE') AND
                //>>LPA090615
                // (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992') THEN
                //   (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992')
                //   AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '513') THEN
                //<<LPA090615
                //   "PWD Quartis Description" := ''
                //ELSE
                Quartis := RecPItemConfigurator."Piece Type Semi-finished" + '-';
                //<<TDL.LPSA.20.04.15
                Quartis += Format(RecPItemConfigurator."Hole Tol") + '(+/-' + Format(RecPItemConfigurator."Hole Tol Max.") + ')';
                Quartis += '-' + Format(RecPItemConfigurator."D Min.") + '/' + Format(RecPItemConfigurator."D Max.") + '-' +
                                          Format(RecPItemConfigurator."Ep Min.") + '/' + Format(RecPItemConfigurator."Ep Max.") + '';
            end
            else
                //>>TDL.LPSA.20.04.15
                //"PWD Quartis Description" := "Piece Type Semi-finished" + '-' + FORMAT("Hole Tol") + '(' + FORMAT("Hole Tol Min.") + '/' +
                //                          FORMAT("Hole Tol Max.") + ')-' + FORMAT("D Min.") + '/' + FORMAT("D Max.") + '-' +
                //                          FORMAT("Ep Min.") + '/' + FORMAT("Ep Max.") + '';
                //IF (RecPItemConfigurator."Location Code" = 'PIE') AND
                //>>LPA090615
                //  (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992') THEN
                //   (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992') AND
                //     (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '513')  THEN
                //>>LPA090615
                //         "PWD Quartis Description" := FORMAT("Hole Tol") + '(' + FORMAT("Hole Tol Min.") + '/' +
                //                             FORMAT("Hole Tol Max.") + ')-' + FORMAT("D Min.") + '/' + FORMAT("D Max.") + '-' +
                //                             FORMAT("Ep Min.") + '/' + FORMAT("Ep Max.") + ''
                //ELSE
                Quartis := RecPItemConfigurator."Piece Type Semi-finished" + '-' + Format(RecPItemConfigurator."Hole Tol") + '(' + Format(RecPItemConfigurator."Hole Tol Min.") + '/' +
                                              Format(RecPItemConfigurator."Hole Tol Max.") + ')-' + Format(RecPItemConfigurator."D Min.") + '/' + Format(RecPItemConfigurator."D Max.") + '-' +
                                              Format(RecPItemConfigurator."Ep Min.") + '/' + Format(RecPItemConfigurator."Ep Max.") + '';
            //>>TDL.LPSA.20.04.15
        end
        else begin
            if RecPItemConfigurator."Hole Tol" <> 0 then
                if RecPItemConfigurator."Hole Tol Min." = -RecPItemConfigurator."Hole Tol Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + '-T' + Format(RecPItemConfigurator."Hole Tol") + '(+/-' + Format(RecPItemConfigurator."Hole Tol Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", '-T', RecPItemConfigurator."Hole Tol", RecPItemConfigurator."Hole Tol Min.", RecPItemConfigurator."Hole Tol Max.");
            if RecPItemConfigurator."External Diameter Tol" <> 0 then
                if RecPItemConfigurator."External Diameter Tol Min." = -RecPItemConfigurator."External Diameter Tol Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xD' + Format(RecPItemConfigurator."External Diameter Tol") + '(+/-' +
                                             Format(RecPItemConfigurator."External Diameter Tol Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription(RecPItemConfigurator."PWD LPSA Description 1", 'xD', RecPItemConfigurator."External Diameter Tol",
                            RecPItemConfigurator."External Diameter Tol Min.", RecPItemConfigurator."External Diameter Tol Max.");
            if ((RecPItemConfigurator."Ep Min." <> 0) or (RecPItemConfigurator."Ep Max." <> 0)) then
                if RecPItemConfigurator."Ep Min." = -RecPItemConfigurator."Ep Max." then
                    RecPItemConfigurator."PWD LPSA Description 1" := RecPItemConfigurator."PWD LPSA Description 1" + 'xE' + '(+/-' + Format(RecPItemConfigurator."Ep Max.") + ')'
                else
                    RecPItemConfigurator."PWD LPSA Description 1" := FctBuildDescription2(RecPItemConfigurator."PWD LPSA Description 1", 'xE', RecPItemConfigurator."Ep Min.", RecPItemConfigurator."Ep Max.");

            TxtLDim1 := Format(RecPItemConfigurator."External Diameter Tol");
            TxtLDim1 := CopyStr(TxtLDim1, 1, StrPos(TxtLDim1, ',') + 1);

            if (RecPItemConfigurator."Hole Tol Min." = -RecPItemConfigurator."Hole Tol Max.") then begin
                //>>TDL.LPSA.20.04.15
                //"PWD Quartis Description" := "Piece Type Semi-finished" + '-';
                //IF (RecPItemConfigurator."Location Code" = 'PIE') AND
                //>>LPA090615
                //  (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992') THEN
                //   (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992') AND
                //   (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '513') THEN
                //<<LPA090615
                //   "PWD Quartis Description" := ''
                //ELSE
                Quartis := RecPItemConfigurator."Piece Type Semi-finished" + '-';
                //<<TDL.LPSA.20.04.15
                Quartis += Format(RecPItemConfigurator."Hole Tol") + '(+/-' + Format(RecPItemConfigurator."Hole Tol Max.") + ')';
                if RecPItemConfigurator."External Diameter Tol" <> 0 then
                    if RecPItemConfigurator."External Diameter Tol Min." = -RecPItemConfigurator."External Diameter Tol Max." then
                        Quartis := Quartis + '-' + Format(RecPItemConfigurator."External Diameter Tol") + '(+/-' +
                                                 Format(RecPItemConfigurator."External Diameter Tol Max.") + ')'
                    else
                        Quartis := FctBuildDescription(Quartis, '-', RecPItemConfigurator."External Diameter Tol",
                                RecPItemConfigurator."External Diameter Tol Min.", RecPItemConfigurator."External Diameter Tol Max.");
                Quartis += '-' + Format(RecPItemConfigurator."Ep Min.") + '/' + Format(RecPItemConfigurator."Ep Max.");
            end
            else begin
                //>>TDL.LPSA.20.04.15
                //"PWD Quartis Description" := "Piece Type Semi-finished" + '-' + FORMAT("Hole Tol") + '(' + FORMAT("Hole Tol Min.") + '/' +
                //                          FORMAT("Hole Tol Max.") + ')-' + FORMAT("External Diameter Tol") + '-' + FORMAT("Ep Min.") +
                //                          '/' + FORMAT("Ep Max.");
                //IF (RecPItemConfigurator."Location Code" = 'PIE') AND
                //>>LPA090615
                // (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992') THEN
                //   (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992') AND
                //     (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '513') THEN
                //   "PWD Quartis Description" := FORMAT("Hole Tol") + '(' + FORMAT("Hole Tol Min.") + '/' +
                //                            FORMAT("Hole Tol Max.") + ')-' + FORMAT("External Diameter Tol") + '-' + FORMAT("Ep Min.") +
                //                            '/' + FORMAT("Ep Max.")
                //ELSE
                Quartis := RecPItemConfigurator."Piece Type Semi-finished" + '-' + Format(RecPItemConfigurator."Hole Tol") + '(' + Format(RecPItemConfigurator."Hole Tol Min.") + '/' +
                                         Format(RecPItemConfigurator."Hole Tol Max.") + ')';
                if RecPItemConfigurator."External Diameter Tol" <> 0 then
                    if RecPItemConfigurator."External Diameter Tol Min." = -RecPItemConfigurator."External Diameter Tol Max." then
                        Quartis := Quartis + '-' + Format(RecPItemConfigurator."External Diameter Tol") + '(+/-' +
                                                 Format(RecPItemConfigurator."External Diameter Tol Max.") + ')'
                    else
                        Quartis := FctBuildDescription(Quartis, '-', RecPItemConfigurator."External Diameter Tol",
                                RecPItemConfigurator."External Diameter Tol Min.", RecPItemConfigurator."External Diameter Tol Max.");

                Quartis += '-' + Format(RecPItemConfigurator."Ep Min.") + '/' + Format(RecPItemConfigurator."Ep Max.");

                //<<TDL.LPSA.20.04.15
            end;
        end;

        //>>CSC
        RecPItemConfigurator."PWD Quartis Description" := CopyStr(Quartis, 1, 40);
        RecPItemConfigurator."Quartis Desc TEST" := BuildQuartisDesc(RecPItemConfigurator);
        //<<CSC

        FctUpdteDescription(RecPItemConfigurator);
    end;


    procedure "---LAP2.02---"()
    begin
    end;


    procedure FctUpdteDescription(RecPItemConfig: Record "PWD Item Configurator")
    var
        RecLItem: Record Item;
    begin
        RecLItem.Reset();
        if RecLItem.Get(RecPItemConfig."Item Code") then begin
            RecLItem.Description := RecPItemConfig."PWD Quartis Description";
            RecLItem.Modify(false);
        end;
    end;


    procedure FctBuildDescription(var TxtPDescription: Text[120]; TxtPText: Text[10]; DecPSize: Decimal; DecPMeasureMin: Decimal; DecPMeasureMax: Decimal): Text[120]
    begin
        //===Build Generic Description===========================================

        if DecPSize <> 0 then
            TxtPDescription := TxtPDescription + TxtPText + Format(DecPSize) + '('
        else
            TxtPDescription := TxtPDescription + TxtPText + '(';

        if DecPMeasureMin > 0 then
            TxtPDescription := TxtPDescription + '+' + Format(DecPMeasureMin) + '/'
        else
            TxtPDescription := TxtPDescription + Format(DecPMeasureMin) + '/';
        if DecPMeasureMax > 0 then
            TxtPDescription := TxtPDescription + '+' + Format(DecPMeasureMax) + ')'
        else
            TxtPDescription := TxtPDescription + Format(DecPMeasureMax) + ')';

        exit(TxtPDescription);
    end;


    procedure FctBuildDescriptionQ(TxtPDescription: Text[120]; TxtPText: Text[10]; DecPSize: Decimal; DecPMeasureMin: Decimal; DecPMeasureMax: Decimal) TxtDescReturn: Text[40]
    var
        TxtLDescToAdd: Text[40];
    begin
        //===Build Generic Description===========================================

        if DecPSize <> 0 then
            TxtPDescription := TxtPDescription + TxtPText + Format(DecPSize) + '('
        else
            TxtPDescription := TxtPDescription + TxtPText + '(';

        //>>FE_LAPIERRETTE_ART01.004: TO 24/09/2012
        //IF DecPMeasureMin >0 THEN
        //   TxtPDescription := TxtPDescription + '+' + FORMAT(DecPMeasureMin) + '/'
        //ELSE
        //   TxtPDescription := TxtPDescription + FORMAT(DecPMeasureMin) + '/';
        //IF DecPMeasureMax > 0 THEN
        //  TxtPDescription := TxtPDescription +  '+' + FORMAT(DecPMeasureMax) + ')'
        //ELSE
        //  TxtPDescription := TxtPDescription + FORMAT(DecPMeasureMax) + ')';

        if DecPMeasureMin > 0 then
            TxtLDescToAdd := TxtLDescToAdd + '+' + Format(DecPMeasureMin) + '/'
        else
            TxtLDescToAdd := TxtLDescToAdd + Format(DecPMeasureMin) + '/';
        if DecPMeasureMax > 0 then
            TxtLDescToAdd := TxtLDescToAdd + '+' + Format(DecPMeasureMax) + ')'
        else
            TxtLDescToAdd := TxtLDescToAdd + Format(DecPMeasureMax) + ')';


        if (StrLen(TxtPDescription) + StrLen(TxtLDescToAdd)) <= MaxStrLen(TxtLDescToAdd) then
            TxtPDescription := TxtPDescription + TxtLDescToAdd;

        //<<FE_LAPIERRETTE_ART01.004: TO 24/09/2012

        TxtDescReturn := CopyStr(TxtPDescription, 1, 40);
    end;


    procedure FctBuildDescription2(var TxtPDescription: Text[120]; TxtPText: Text[10]; DecPMeasureMin: Decimal; DecPMeasureMax: Decimal): Text[120]
    begin
        //===Build Generic Description===========================================

        TxtPDescription := TxtPDescription + TxtPText + Format(DecPMeasureMin) + '/' + Format(DecPMeasureMax);
        exit(TxtPDescription);
    end;


    procedure FctBuildDescriptionQ2(TxtPDescription: Text[120]; TxtPText: Text[10]; DecPMeasureMin: Decimal; DecPMeasureMax: Decimal) TxtDescReturn: Text[40]
    var
        TxtLDescToAdd: Text[40];
    begin
        //===Build Generic Description===========================================

        TxtLDescToAdd := TxtPText + Format(DecPMeasureMin) + '/' + Format(DecPMeasureMax);

        if (StrLen(TxtPDescription) + StrLen(TxtLDescToAdd)) <= MaxStrLen(TxtLDescToAdd) then
            TxtPDescription := TxtPDescription + TxtLDescToAdd;

        //<<FE_LAPIERRETTE_ART01.004: TO 24/09/2012

        TxtDescReturn := CopyStr(TxtPDescription, 1, 40);
    end;


    procedure "--- LAP2.12 ---"()
    begin
    end;


    procedure BuildQuartisDesc(_ItemConfig: Record "PWD Item Configurator"): Text[40]
    var
        IntLPos1: Integer;
        IntLPos2: Integer;
        TxtLQuartis: Text[40];
    begin
        TxtLQuartis := '';

        case _ItemConfig."Product Type" of
            _ItemConfig."Product Type"::STONE:
                begin
                    IntLPos1 := StrPos(_ItemConfig."PWD LPSA Description 1", _ItemConfig."Piece Type Stone");
                    IntLPos2 := IntLPos1 + StrLen(_ItemConfig."Piece Type Stone") + 1;
                end;
            _ItemConfig."Product Type"::PREPARAGE:
                begin
                    IntLPos1 := StrPos(_ItemConfig."PWD LPSA Description 1", _ItemConfig."Piece Type Preparage");
                    IntLPos2 := IntLPos1 + StrLen(_ItemConfig."Piece Type Preparage") + 1;
                end;
            _ItemConfig."Product Type"::"LIFTED AND ELLIPSES":
                begin
                    IntLPos1 := StrPos(_ItemConfig."PWD LPSA Description 1", _ItemConfig."Piece Type Lifted&Ellipses");
                    IntLPos2 := IntLPos1 + StrLen(_ItemConfig."Piece Type Lifted&Ellipses") + 1;
                end;
            _ItemConfig."Product Type"::"SEMI-FINISHED":
                begin
                    IntLPos1 := StrPos(_ItemConfig."PWD LPSA Description 1", _ItemConfig."Piece Type Semi-finished");
                    IntLPos2 := IntLPos1 + StrLen(_ItemConfig."Piece Type Semi-finished") + 1;
                end;
        end;

        if IntLPos1 = 0 then
            exit('');

        //TxtLQuartis := COPYSTR(_ItemConfig."PWD LPSA Description 1",1,40);
        //IF (COPYSTR(_ItemConfig."Item Code",1,2) IN ['80','99']) OR
        //    (COPYSTR(_ItemConfig."Item Code",1,3) IN ['521']) THEN
        TxtLQuartis := CopyStr(_ItemConfig."PWD LPSA Description 1", IntLPos1, 40);

        if CopyStr(_ItemConfig."Item Code", 1, 3) in ['512', '513'] then
            TxtLQuartis := CopyStr(_ItemConfig."PWD LPSA Description 1", IntLPos2, 40);

        exit(TxtLQuartis);
    end;
}

