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
        TxtLDim1: Text[30];
        TxtLDim2: Text[30];
        Longueur: Integer;
    begin
        with RecPItemConfigurator do begin
            if "Matter Stone" <> '' then
                "PWD LPSA Description 1" := CopyStr("Matter Stone", 1, 1) + LowerCase(CopyStr("Matter Stone", 2, StrLen("Matter Stone") - 1))
            else
                "PWD LPSA Description 1" := '';
            "PWD LPSA Description 1" += Format(Number) + Orientation + '-' + "Piece Type Stone";

            Longueur := StrLen("PWD LPSA Description 1") - StrLen("Piece Type Stone") + 1;

            "PWD LPSA Description 2" := '';

            if Hole <> 0 then
                if "Hole Min." = -"Hole Max." then
                    "PWD LPSA Description 1" := "PWD LPSA Description 1" + '-T' + Format(Hole) + '(+/-' + Format("Hole Max.") + ')'
                else
                    "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", '-T', Hole, "Hole Min.", "Hole Max.");

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
            if (Hole = 0) then begin
                if "External Diameter" <> 0 then
                    if "External Diameter Min." = -"External Diameter Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + '-D' + Format("External Diameter") + '(+/-' +
                                                                               Format("External Diameter Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", '-D', "External Diameter", "External Diameter Min.",
                                                                    "External Diameter Max.");
            end else
                if "External Diameter" <> 0 then
                    if "External Diameter Min." = -"External Diameter Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xD' + Format("External Diameter") + '(+/-' +
                                                                               Format("External Diameter Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'xD', "External Diameter", "External Diameter Min.",
                                                                    "External Diameter Max.");
            if (Hole = 0) and ("External Diameter" = 0) then begin
                if Thickness <> 0 then
                    if "Thickness Min." = -"Thickness Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + '-E' + Format(Thickness) + '(+/-' + Format("Thickness Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", '-E', Thickness, "Thickness Min.", "Thickness Max.");
            end else
                if Thickness <> 0 then
                    if "Thickness Min." = -"Thickness Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xE' + Format(Thickness) + '(+/-' + Format("Thickness Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'xE', Thickness, "Thickness Min.", "Thickness Max.");
            //>>NDBI

            if "Recess Diametre" <> 0 then
                if "Recess Diametre Min." = -"Recess Diametre Max." then
                    "PWD LPSA Description 2" := 'C' + Format("Recess Diametre") + '(+/-' + Format("Recess Diametre Max.") + ')'
                else
                    if "Recess Diametre Min." < 0 then
                        "PWD LPSA Description 2" := 'C' + Format("Recess Diametre") + '(' + Format("Recess Diametre Min.") + '/+' +
                                                      Format("Recess Diametre Max.") + ')'

                    else
                        "PWD LPSA Description 2" := 'C' + Format("Recess Diametre") + '(+' + Format("Recess Diametre Min.") + '/+' +
                                                      Format("Recess Diametre Max.") + ')';


            if "Hole Length" <> 0 then
                if "Hole Length Min." = -"Hole Length Max." then
                    "PWD LPSA Description 2" := "PWD LPSA Description 2" + 'xL' + Format("Hole Length") + '(+/-' + Format("Hole Length Max.") + ')'
                else
                    "PWD LPSA Description 2" := FctBuildDescription("PWD LPSA Description 2", 'xL', "Hole Length", "Hole Length Min.", "Hole Length Max.");


            if "Height Band" <> 0 then
                if "Height Band Min." = -"Height Band Max." then
                    "PWD LPSA Description 2" := "PWD LPSA Description 2" + 'xR' + Format("Height Band") + '(+/-' + Format("Height Band Max.") + ')'
                else
                    "PWD LPSA Description 2" := FctBuildDescription("PWD LPSA Description 2", 'xR', "Height Band", "Height Band Min.", "Height Band Max.");

            if "Height Cambered" <> 0 then
                if "Height Cambered Min." = -"Height Cambered Max." then
                    "PWD LPSA Description 2" := "PWD LPSA Description 2" + 'xB' + Format("Height Cambered") +
                                           '(+/-' + Format("Height Cambered Max.") + ')'
                else
                    "PWD LPSA Description 2" := FctBuildDescription("PWD LPSA Description 2", 'xB', "Height Cambered", "Height Cambered Min.",
                                                                "Height Cambered Max.");


            if "Height Half Glazed" <> 0 then
                if "Height Half Glazed Min." = -"Height Half Glazed Max." then
                    "PWD LPSA Description 2" := "PWD LPSA Description 2" + 'xG' + Format("Height Half Glazed") + '(+/-' +
                                             Format("Height Half Glazed Max.") + ')'
                else
                    "PWD LPSA Description 2" := FctBuildDescription("PWD LPSA Description 2", 'xG', "Height Half Glazed", "Height Half Glazed Min.",
                                                                "Height Half Glazed Max.");


            TxtLDim1 := Format(Hole);
            TxtLDim2 := Format("External Diameter");

            if StrPos(TxtLDim1, ',') > 0 then
                TxtLDim1 := CopyStr(TxtLDim1, 1, StrPos(TxtLDim1, ',') + 1);
            if StrPos(TxtLDim2, ',') > 0 then
                TxtLDim2 := CopyStr(TxtLDim2, 1, StrPos(TxtLDim2, ',') + 1);

            "PWD Quartis Description" := CopyStr("PWD LPSA Description 1", Longueur, 40);

            //>>CSC
            "Quartis Desc TEST" := BuildQuartisDesc(RecPItemConfigurator);
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

    end;


    procedure FctConfigDescPrepa(var RecPItemConfigurator: Record "PWD Item Configurator")
    var
        TxtLQuartisDesc: Text[120];
    begin
        with RecPItemConfigurator do begin
            if "Matter Preparage" <> '' then
                "PWD LPSA Description 1" := CopyStr("Matter Preparage", 1, 1) + LowerCase(CopyStr("Matter Preparage", 2, StrLen("Matter Preparage") - 1))
            else
                "PWD LPSA Description 1" := '';
            "PWD LPSA Description 1" += Format(Number) + Orientation + '-' + "Piece Type Preparage";

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
            "PWD Quartis Description" := "Piece Type Preparage" + '-';
            //<<TDL.LPSA.20.04.15
            // 20200615-ANF modification ordre de designation ENTRETOISE

            if "Piece Type Preparage" in ['CARRELET', 'ENTRETOISE'] then begin
                if (("Width / Depth Min." <> 0) or ("Width / Depth Max." <> 0)) then
                    if "Width / Depth Min." = -"Width / Depth Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + '-L' + '+/-' + Format("Width / Depth Max.")
                    else
                        "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", '-L', "Width / Depth Min.", "Width / Depth Max.");

                if (("Thick Min." <> 0) or ("Thick Max." <> 0)) then
                    if "Thick Min." = -"Thickness Min." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xE' + '+/-' + Format("Thick Min.")
                    else
                        "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", 'xE', "Thick Min.", "Thick Max.");


                if (("Height Min." <> 0) or ("Height Max." <> 0)) then
                    if "Height Min." = -"Height Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xH' + '+/-' + Format("Height Max.")
                    else
                        "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", 'xH', "Height Min.", "Height Max.");



                if (("Width Min." <> 0) or ("Width Max." <> 0)) then
                    if "Width Min." = -"Width Max." then begin
                        TxtLQuartisDesc := "PWD Quartis Description" + 'L' + '-/+' + Format("Width Max.");
                        "PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                    end
                    else
                        "PWD Quartis Description" := FctBuildDescriptionQ2("PWD Quartis Description", 'L', "Width Min.", "Width Max.");

                if (("Height Min." <> 0) or ("Height Max." <> 0)) then
                    if "Height Min." = -"Height Max." then begin
                        TxtLQuartisDesc := "PWD Quartis Description" + 'H' + '+/-' + Format("Height Max.");
                        "PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                    end
                    else
                        "PWD Quartis Description" := FctBuildDescriptionQ2("PWD Quartis Description", 'xH', "Height Min.", "Height Max.");

                if (("Width / Depth Min." <> 0) or ("Width / Depth Max." <> 0)) then
                    if "Width / Depth Min." = -"Width / Depth Max." then begin
                        TxtLQuartisDesc := "PWD Quartis Description" + 'P' + '+/-' + Format("Width / Depth Max.");
                        "PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                    end
                    else
                        "PWD Quartis Description" := FctBuildDescriptionQ2("PWD Quartis Description", 'xP', "Width / Depth Min.", "Width / Depth Max.");
            end
            else
                if "Piece Type Preparage" in ['CHEVILLE', 'GOUPILLE'] then begin
                    if (("Diameter Min." <> 0) or ("Diameter Max." <> 0)) then
                        if "Diameter Min." = -"Diameter Max." then
                            "PWD LPSA Description 1" := "PWD LPSA Description 1" + '-D' + '+/-' + Format("Diameter Max.")
                        else
                            "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", '-D', "Diameter Min.", "Diameter Max.");
                    if (("Width / Depth Min." <> 0) or ("Width / Depth Min." <> 0)) then
                        if "Width / Depth Min." = -"Width / Depth Max." then
                            "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xL' + '+/-' + Format("Width / Depth Max.")
                        else
                            "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", 'xL', "Width / Depth Min.", "Width / Depth Max.");
                    if (("Diameter Min." <> 0) or ("Diameter Max." <> 0)) then
                        if "Diameter Min." = -"Diameter Max." then begin
                            TxtLQuartisDesc := "PWD Quartis Description" + 'D' + '+/-' + Format("Diameter Max.");
                            "PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                        end
                        else
                            "PWD Quartis Description" := FctBuildDescriptionQ2("PWD Quartis Description", 'D', "Diameter Min.", "Diameter Max.");

                    if (("Width / Depth Min." <> 0) or ("Width / Depth Max." <> 0)) then
                        if "Width / Depth Min." = -"Width / Depth Max." then begin
                            TxtLQuartisDesc := "PWD Quartis Description" + 'xL' + '+/-' + Format("Width / Depth Max.");
                            "PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                        end
                        else
                            "PWD Quartis Description" := FctBuildDescriptionQ2("PWD Quartis Description", 'xL', "Width / Depth Min.", "Width / Depth Max.");
                end
                //
                else
                    if "Piece Type Preparage" in ['BARRE', 'C-PIVOT', 'NON PERCE'] then begin
                        if (("Diameter Min." <> 0) or ("Diameter Max." <> 0)) then begin
                            "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", '-D', "Diameter Min.", "Diameter Max.");
                            "PWD Quartis Description" := FctBuildDescriptionQ2("PWD Quartis Description", 'D', "Diameter Min.", "Diameter Max.");
                        end;
                        if ("Thick Min." <> 0) or ("Thick Max." <> 0) then begin
                            "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", 'xE', "Thick Min.", "Thick Max.");
                            "PWD Quartis Description" := FctBuildDescriptionQ2("PWD Quartis Description", 'xE', "Thick Min.", "Thick Max.");
                        end;
                    end
                    else begin
                        if (("Piercing Min." <> 0) or ("Piercing Max." <> 0)) then begin
                            "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", '-T', "Piercing Min.", "Piercing Max.");
                            "PWD Quartis Description" := FctBuildDescriptionQ2("PWD Quartis Description", 'T', "Piercing Min.", "Piercing Max.");
                        end;

                        if Note <> 0 then begin
                            "PWD LPSA Description 1" := "PWD LPSA Description 1" + '(' + Format(Note) + ')';
                            TxtLQuartisDesc := "PWD Quartis Description" + '(' + Format(Note) + ')';
                            "PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                        end;

                        if (("Diameter Min." <> 0) or ("Diameter Max." <> 0)) then
                            if "Diameter Min." = -"Diameter Max." then begin
                                "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xD' + '+/-' + Format("Diameter Max.");
                                TxtLQuartisDesc := "PWD Quartis Description" + 'xD' + '+/-' + Format("Diameter Max.");
                                "PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                            end
                            else begin
                                "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", 'xD', "Diameter Min.", "Diameter Max.");
                                "PWD Quartis Description" := FctBuildDescriptionQ2("PWD Quartis Description", 'xD', "Diameter Min.", "Diameter Max.");
                            end;
                        if ("Thick Min." <> 0) or ("Thick Max." <> 0) then
                            if "Thick Min." = -"Thick Max." then begin
                                "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xE' + '+/-' + Format("Thick Max.");
                                TxtLQuartisDesc := "PWD Quartis Description" + 'xE' + '+/-' + Format("Thick Max.");
                                "PWD Quartis Description" := CopyStr(TxtLQuartisDesc, 1, 40);
                            end
                            else begin
                                "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", 'xE', "Thick Min.", "Thick Max.");
                                "PWD Quartis Description" := FctBuildDescriptionQ2("PWD Quartis Description", 'xE', "Thick Min.", "Thick Max.");
                            end;
                    end;

            "PWD LPSA Description 2" := '';

            //>>CSC
            "Quartis Desc TEST" := BuildQuartisDesc(RecPItemConfigurator);
            //<<CSC

            FctUpdteDescription(RecPItemConfigurator);

        end;
    end;


    procedure FctConfigDescLifted(var RecPItemConfigurator: Record "PWD Item Configurator")
    var
        TxtLChar: Text[1];
    begin
        with RecPItemConfigurator do begin

            "PWD LPSA Description 2" := '';
            if "Matter Lifted&Ellipses" <> '' then
                "PWD LPSA Description 1" := CopyStr("Matter Lifted&Ellipses", 1, 1) +
                                        LowerCase(CopyStr("Matter Lifted&Ellipses", 2, StrLen("Matter Lifted&Ellipses") - 1))
            else
                "PWD LPSA Description 1" := '';
            "PWD LPSA Description 1" += Format(Number) + Orientation + '-' + "Piece Type Lifted&Ellipses";

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
            "PWD Quartis Description" := "Piece Type Lifted&Ellipses";
            //<<TDL.LPSA.20.04.15

            //->> 20200615-ANF modification ordre de designation des LEVEES

            if "Piece Type Lifted&Ellipses" = 'LEVEES' then begin

                //Inversion L et A
                if ("Lg Tol" <> 0) then begin
                    if "Lg Tol Min." = -"Lg Tol Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + '-L' + Format("Lg Tol") + '(+/-' + Format("Lg Tol Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'xL', "Lg Tol", "Lg Tol Min.", "Lg Tol Max.");
                    "PWD Quartis Description" := "PWD Quartis Description" + '-L' + Format("Lg Tol");
                end;


                if ("Height Tol" <> 0) then begin
                    //IF "Height Min. Tol" = -"Height Max. Tol" THEN
                    //  "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xH' + FORMAT("Height Tol") + '(+/-' + FORMAT("Height Max. Tol") + ')'
                    //ELSE
                    //  "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'xH',"Height Tol","Height Min. Tol","Height Max. Tol");
                    //"PWD Quartis Description" := "PWD Quartis Description" + '-H' + FORMAT("Height Tol");
                    if CopyStr("Item Code", 1, 4) = '9930' then
                        TxtLChar := 'E'
                    else
                        TxtLChar := 'H';
                    if "Height Min. Tol" = -"Height Max. Tol" then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'x' + TxtLChar + Format("Height Tol")
                                                    + '(+/-' + Format("Height Max. Tol") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'x' + TxtLChar, "Height Tol",
                                                      "Height Min. Tol", "Height Max. Tol");
                    "PWD Quartis Description" := "PWD Quartis Description" + '-' + TxtLChar + Format("Height Tol");
                end;

                if ("Thick Tol" <> 0) then begin
                    //IF "Thick Min. Tol" = -"Thick Max. Tol" THEN
                    //  "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xE' + FORMAT("Thick Tol") + '(+/-' + FORMAT("Thick Max. Tol") + ')'
                    //ELSE
                    //  "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1",'xE',"Thick Tol","Thick Min. Tol","Thick Max. Tol");
                    //"PWD Quartis Description" := "PWD Quartis Description" + '-E' + FORMAT("Thick Tol");
                    if CopyStr("Item Code", 1, 4) = '9930' then
                        TxtLChar := 'H'
                    else
                        TxtLChar := 'E';
                    if "Thick Min. Tol" = -"Thick Max. Tol" then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'x' + TxtLChar + Format("Thick Tol")
                                                   + '(+/-' + Format("Thick Max. Tol") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'x' + TxtLChar, "Thick Tol",
                                                    "Thick Min. Tol", "Thick Max. Tol");
                    "PWD Quartis Description" := "PWD Quartis Description" + '-' + TxtLChar + Format("Thick Tol");

                end;

                if (Angle <> 0) then begin
                    if "Angle Min." = -"Angle Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xA' + Format(Angle) + '(+/-' + Format("Angle Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", '-A', Angle, "Angle Min.", "Angle Max.");
                    "PWD Quartis Description" := "PWD Quartis Description" + 'xA' + Format(Angle);
                end;

                //<<- 20200615-ANF modification ordre de designation des LEVEES


            end
            else
                if "Piece Type Lifted&Ellipses" in ['ELLIPSES', 'PLAT POLI'] then begin
                    if ("Diameter Tol" <> 0) then begin
                        if "Diameter Tol Min." = -"Diameter Tol Max." then
                            "PWD LPSA Description 1" := "PWD LPSA Description 1" + '-D' + Format("Diameter Tol") + '(+/-' + Format("Diameter Tol Max.") + ')'
                        else
                            "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", '-D', "Diameter Tol", "Diameter Tol Min.",
                                                                         "Diameter Tol Max.");
                        "PWD Quartis Description" := "PWD Quartis Description" + '-D' + Format("Diameter Tol");
                    end;


                    if ("Thick Tol" <> 0) then begin
                        if "Thick Min. Tol" = -"Thick Max. Tol" then
                            "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xP' + Format("Thick Tol") + '(+/-' + Format("Thick Max. Tol") + ')'
                        else
                            "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'xP', "Thick Tol", "Thick Min. Tol", "Thick Max. Tol");
                        "PWD Quartis Description" := "PWD Quartis Description" + '-P' + Format("Thick Tol");
                    end;


                    if ("Lg Tol" <> 0) then begin
                        if "Lg Tol Min." = -"Lg Tol Max." then
                            "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xL' + Format("Lg Tol") + '(+/-' + Format("Lg Tol Max.") + ')'
                        else
                            "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'xL', "Lg Tol", "Lg Tol Min.", "Lg Tol Max.");
                        "PWD Quartis Description" := "PWD Quartis Description" + '-L' + Format("Lg Tol");
                    end;

                    if "Piece Type Lifted&Ellipses" = 'ELLIPSES' then
                        "PWD LPSA Description 2" := 'xRA' + Format("R / Arc") + 'xRC' + Format("R / Corde");

                end
                else
                    if "Piece Type Lifted&Ellipses" in ['GOUPILLE', 'CHEVILLE'] then begin
                        if ("Diameter Tol" <> 0) then begin
                            if "Diameter Tol Min." = -"Diameter Tol Max." then
                                "PWD LPSA Description 1" := "PWD LPSA Description 1" + '-D' + Format("Diameter Tol") + '(+/-' + Format("Diameter Tol Max.") + ')'
                            else
                                "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", '-D', "Diameter Tol", "Diameter Tol Min.",
                                                                            "Diameter Tol Max.");
                            "PWD Quartis Description" := "PWD Quartis Description" + '-D' + Format("Diameter Tol");
                        end;
                        if ("Lg Tol" <> 0) then begin
                            if "Lg Tol Min." = -"Lg Tol Max." then
                                "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xL' + Format("Lg Tol") + '(+/-' + Format("Lg Tol Max.") + ')'
                            else
                                "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'xL', "Lg Tol", "Lg Tol Min.", "Lg Tol Max.");
                            "PWD Quartis Description" := "PWD Quartis Description" + '-L' + Format("Lg Tol");
                        end;
                    end
                    else begin
                        if ("Thick Tol" <> 0) then
                        //20200615 ANF inversion designation POLI4FACES 5211

                        begin
                            //IF "Thick Min. Tol" = -"Thick Max. Tol" THEN
                            //  "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xL' + FORMAT("Thick Tol") + '(+/-' + FORMAT("Thick Max. Tol") + ')'
                            //ELSE
                            //  "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1",'xL',"Thick Tol","Thick Min. Tol","Thick Max. Tol");
                            //"PWD Quartis Description" := "PWD Quartis Description" + '-L' + FORMAT("Thick Tol");
                            if CopyStr("Item Code", 1, 4) = '5211' then
                                TxtLChar := 'L'
                            else
                                TxtLChar := 'P';
                            if "Lg Tol Min." = -"Lg Tol Max." then
                                "PWD LPSA Description 1" := "PWD LPSA Description 1" + '-' + TxtLChar + Format("Lg Tol")
                                                         + '(+/-' + Format("Lg Tol Max.") + ')'
                            else
                                "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'x' + TxtLChar, "Lg Tol",
                                                          "Lg Tol Min.", "Lg Tol Max.");
                            "PWD Quartis Description" := "PWD Quartis Description" + '-' + TxtLChar + Format("Lg Tol");

                        end;


                        if ("Height Tol" <> 0) then begin
                            //IF "Height Min. Tol" = -"Height Max. Tol" THEN
                            //  "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xH' + FORMAT("Height Tol") + '(+/-' +  FORMAT("Height Max. Tol") + ')'
                            //ELSE
                            //  "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1",'xH',"Height Tol","Height Min. Tol","Height Max. Tol");
                            // "PWD Quartis Description" := "PWD Quartis Description" + '-H' + FORMAT("Height Tol");
                            if CopyStr("Item Code", 1, 4) = '5211' then
                                TxtLChar := 'E'
                            else
                                TxtLChar := 'H';
                            if "Height Min. Tol" = -"Height Max. Tol" then
                                "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'x' + TxtLChar + Format("Height Tol")
                                                           + '(+/-' + Format("Height Max. Tol") + ')'
                            else
                                "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'x' + TxtLChar, "Height Tol",
                                                      "Height Min. Tol", "Height Max. Tol");
                            "PWD Quartis Description" := "PWD Quartis Description" + '-' + TxtLChar + Format("Height Tol");

                        end;

                        if ("Lg Tol" <> 0) then begin
                            //IF "Lg Tol Min." = -"Lg Tol Max." THEN
                            //  "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xP' + FORMAT("Lg Tol") + '(+/-' + FORMAT("Lg Tol Max.") + ')'
                            //ELSE
                            //  "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'xP',"Lg Tol","Lg Tol Min.","Lg Tol Max.");
                            //"PWD Quartis Description" := "PWD Quartis Description" + '-P' + FORMAT("Lg Tol");

                            //20200615 ANF Inversion designation POLI4FACES 5211
                            if CopyStr("Item Code", 1, 4) = '5211' then
                                TxtLChar := 'H'
                            else
                                TxtLChar := 'L';
                            if "Thick Min. Tol" = -"Thick Max. Tol" then
                                "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'x' + TxtLChar + Format("Thick Tol")
                                                             + '(+/-' + Format("Thick Max. Tol") + ')'
                            else
                                "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'x' + TxtLChar, "Thick Tol",
                                                        "Thick Min. Tol", "Thick Max. Tol");
                            "PWD Quartis Description" := "PWD Quartis Description" + '-' + TxtLChar + Format("Thick Tol");

                        end;

                        //20200615 ANF Inversion designation POLI4FACES 5211

                    end;

            //>>CSC
            "Quartis Desc TEST" := BuildQuartisDesc(RecPItemConfigurator);
            //<<CSC

            FctUpdteDescription(RecPItemConfigurator);

        end;
    end;


    procedure FctConfigDescSemiFinish(var RecPItemConfigurator: Record "PWD Item Configurator")
    var
        TxtLDim1: Text[30];
        Quartis: Text[120];
    begin
        with RecPItemConfigurator do begin
            "PWD LPSA Description 2" := '';
            if "Matter Semi-finished" <> '' then
                "PWD LPSA Description 1" := CopyStr("Matter Semi-finished", 1, 1) +
                                        LowerCase(CopyStr("Matter Semi-finished", 2, StrLen("Matter Semi-finished") - 1))
            else
                "PWD LPSA Description 1" := '';
            "PWD LPSA Description 1" += Format(Number) + Orientation + '-' + "Piece Type Semi-finished";

            if "Piece Type Semi-finished" = 'GRANDI' then begin
                if "Hole Tol" <> 0 then
                    if "Hole Tol Min." = -"Hole Tol Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + '-T' + Format("Hole Tol") + '(+/-' + Format("Hole Tol Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", '-T', "Hole Tol", "Hole Tol Min.", "Hole Tol Max.");

                if (("D Min." <> 0) or ("D Max." <> 0)) then
                    if "D Min." = -"D Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xD' + '(+/-' + Format("D Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", 'xD', "D Min.", "D Max.");

                if (("Ep Min." <> 0) or ("Ep Max." <> 0)) then
                    if "Ep Min." = -"Ep Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xE' + '(+/-' + Format("Ep Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", 'xE', "Ep Min.", "Ep Max.");

                TxtLDim1 := Format("Hole Tol");
                TxtLDim1 := CopyStr(TxtLDim1, 1, StrPos(TxtLDim1, ',') + 1);
                if ("Hole Tol Min." = -"Hole Tol Max.") then begin
                    //>>TDL.LPSA.20.04.15
                    //IF (RecPItemConfigurator."Location Code" = 'PIE') AND
                    //>>LPA090615
                    // (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992') THEN
                    //   (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '802') AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '992')
                    //   AND (COPYSTR(RecPItemConfigurator."Item Code",1,3) <> '513') THEN
                    //<<LPA090615
                    //   "PWD Quartis Description" := ''
                    //ELSE
                    Quartis := "Piece Type Semi-finished" + '-';
                    //<<TDL.LPSA.20.04.15
                    Quartis += Format("Hole Tol") + '(+/-' + Format("Hole Tol Max.") + ')';
                    Quartis += '-' + Format("D Min.") + '/' + Format("D Max.") + '-' +
                                              Format("Ep Min.") + '/' + Format("Ep Max.") + '';
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
                    Quartis := "Piece Type Semi-finished" + '-' + Format("Hole Tol") + '(' + Format("Hole Tol Min.") + '/' +
                                              Format("Hole Tol Max.") + ')-' + Format("D Min.") + '/' + Format("D Max.") + '-' +
                                              Format("Ep Min.") + '/' + Format("Ep Max.") + '';
                //>>TDL.LPSA.20.04.15
            end
            else begin
                if "Hole Tol" <> 0 then
                    if "Hole Tol Min." = -"Hole Tol Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + '-T' + Format("Hole Tol") + '(+/-' + Format("Hole Tol Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", '-T', "Hole Tol", "Hole Tol Min.", "Hole Tol Max.");
                if "External Diameter Tol" <> 0 then
                    if "External Diameter Tol Min." = -"External Diameter Tol Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xD' + Format("External Diameter Tol") + '(+/-' +
                                                 Format("External Diameter Tol Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription("PWD LPSA Description 1", 'xD', "External Diameter Tol",
                                "External Diameter Tol Min.", "External Diameter Tol Max.");
                if (("Ep Min." <> 0) or ("Ep Max." <> 0)) then
                    if "Ep Min." = -"Ep Max." then
                        "PWD LPSA Description 1" := "PWD LPSA Description 1" + 'xE' + '(+/-' + Format("Ep Max.") + ')'
                    else
                        "PWD LPSA Description 1" := FctBuildDescription2("PWD LPSA Description 1", 'xE', "Ep Min.", "Ep Max.");

                TxtLDim1 := Format("External Diameter Tol");
                TxtLDim1 := CopyStr(TxtLDim1, 1, StrPos(TxtLDim1, ',') + 1);

                if ("Hole Tol Min." = -"Hole Tol Max.") then begin
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
                    Quartis := "Piece Type Semi-finished" + '-';
                    //<<TDL.LPSA.20.04.15
                    Quartis += Format("Hole Tol") + '(+/-' + Format("Hole Tol Max.") + ')';
                    if "External Diameter Tol" <> 0 then
                        if "External Diameter Tol Min." = -"External Diameter Tol Max." then
                            Quartis := Quartis + '-' + Format("External Diameter Tol") + '(+/-' +
                                                     Format("External Diameter Tol Max.") + ')'
                        else
                            Quartis := FctBuildDescription(Quartis, '-', "External Diameter Tol",
                                    "External Diameter Tol Min.", "External Diameter Tol Max.");
                    Quartis += '-' + Format("Ep Min.") + '/' + Format("Ep Max.");
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
                    Quartis := "Piece Type Semi-finished" + '-' + Format("Hole Tol") + '(' + Format("Hole Tol Min.") + '/' +
                                             Format("Hole Tol Max.") + ')';
                    if "External Diameter Tol" <> 0 then
                        if "External Diameter Tol Min." = -"External Diameter Tol Max." then
                            Quartis := Quartis + '-' + Format("External Diameter Tol") + '(+/-' +
                                                     Format("External Diameter Tol Max.") + ')'
                        else
                            Quartis := FctBuildDescription(Quartis, '-', "External Diameter Tol",
                                    "External Diameter Tol Min.", "External Diameter Tol Max.");

                    Quartis += '-' + Format("Ep Min.") + '/' + Format("Ep Max.");

                    //<<TDL.LPSA.20.04.15
                end;
            end;

            //>>CSC
            "PWD Quartis Description" := CopyStr(Quartis, 1, 40);
            "Quartis Desc TEST" := BuildQuartisDesc(RecPItemConfigurator);
            //<<CSC

            FctUpdteDescription(RecPItemConfigurator);
        end;
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
        TxtLQuartis: Text[40];
        IntLPos1: Integer;
        IntLPos2: Integer;
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

