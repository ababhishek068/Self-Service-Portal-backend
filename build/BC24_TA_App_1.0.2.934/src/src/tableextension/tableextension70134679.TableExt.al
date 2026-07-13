TableExtension 50010 tableextension70134679 extends "Dimension Value"
{
    fields
    {


        field(39003900; Picture; Blob)
        {
            SubType = Bitmap;
        }


        field(39003905; HOD; Code[50])
        {
            // TableRelation = "HR-Employee"."No." where(HOD = const(true));
            TableRelation = "User Setup"."User ID";
        }
        field(39003906; DEAN; Code[50])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                //ApprovalTemplates.RESET;
                //ApprovalTemplates.SETRANGE(ApprovalTemplates."Responsibility Center",Code);
                //ApprovalTemplates.SETFILTER(
            end;
        }
        field(39003907; DIRECTOR; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(39003908; "Old Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;
        }
        field(39003909; "School Code"; Code[20]) { }
        field(50034; "Mpesa Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(50035; "Cash Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(50001; "Fore Coart Station"; Boolean) { }

        field(39003910; "Total Income Dept"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Initial Entry Global Dim. 1" = field(Code), "Posting Date" = field("Date Filter")));


        }
        field(39003911; Recurrent; Decimal)
        {
            CalcFormula = sum("G/L Entry".Amount where("G/L Account No." = filter('6000000' .. '6990000'),
                                                        "Posting Date" = field("Date Filter"),
                                                        "Global Dimension 2 Code" = field(Code)));
            FieldClass = FlowField;
        }
        field(39003912; Capital; Decimal)
        {
            CalcFormula = sum("G/L Entry".Amount where("Posting Date" = field("Date Filter"),
                                                        "G/L Account No." = filter('1000000' .. '1999000'),
                                                        "Global Dimension 2 Code" = field(Code)));
            FieldClass = FlowField;
        }
        field(39003913; "Total Expenditure"; Decimal)
        {
            CalcFormula = sum("Payment Line".Amount where("Date" = field("Date Filter"),
                                                       "Global Dimension 1 Code" = field("Code")));
            //CalcFormula = SUM("Payments Header"."Total Payment Amount" where("Date" = field("Date Filter"),
            //"Global Dimension 1 Code" = field("Code"), Posted = filter(true)));
            FieldClass = FlowField;
        }
        field(50113; "Total Receipt"; Decimal)
        {
            CalcFormula = sum("Receipt Line q".Amount where("Date" = field("Date Filter"),
                                                                    "Global Dimension 1 Code" = field("Code")));
            //CalcFormula = sum("Receipts Header"."Total Amount" where("Document Date" = field("Date Filter"),
            // "Global Dimension 1 Code" = field("Code"), Posted = filter(true)));
            FieldClass = FlowField;
        }
        field(50114; "Total Receipt Cash"; Decimal)
        {
            CalcFormula = sum("Receipt Line q".Amount where("Date" = field("Date Filter"),
            "Global Dimension 1 Code" = field("Code"), "Pay Mode" = filter(Cash)));

            //CalcFormula = sum("Receipts Header"."Total Amount" where("Document Date" = field("Date Filter"),
            //"Global Dimension 1 Code" = field("Code"), Posted = filter(true), "Pay Mode" = filter(Cash)));
            FieldClass = FlowField;
        }
        field(50115; "Total Receipt MPESA"; Decimal)
        {
            CalcFormula = sum("Receipt Line q".Amount where("Date" = field("Date Filter"),
                                                            "Global Dimension 1 Code" = field("Code"), "Pay Mode" = filter(MPESA)));
            //CalcFormula = sum("Receipts Header"."Total Amount" where("Document Date" = field("Date Filter"),
            //"Global Dimension 1 Code" = field("Code"), Posted = filter(true), "Pay Mode" = filter(MPESA)));
            FieldClass = FlowField;
        }
        field(50515; "Total Receipt PDQ"; Decimal)
        {
            CalcFormula = sum("Receipt Line q".Amount where("Date" = field("Date Filter"),
                                                                    "Global Dimension 1 Code" = field("Code"), "Pay Mode" = filter(PDQ)));
            //CalcFormula = sum("Receipts Header"."Total Amount" where("Document Date" = field("Date Filter"),
            //"Global Dimension 1 Code" = field("Code"), Posted = filter(true), "Pay Mode" = filter(PDQ)));
            FieldClass = FlowField;
        }
        field(39003914; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }

        field(39003917; Division; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('DIVISION'));
        }

        field(39003918; "Invoice Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(39003919; "Receipt Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }

    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF CheckIfDimValueUsed THEN
      ERROR(Text000,GetCheckDimErr);

    DimValueComb.SETRANGE("Dimension 1 Code","Dimension Code");
    DimValueComb.SETRANGE("Dimension 1 Value Code",Code);
    #6..20
    AnalysisSelectedDim.SETRANGE("Dimension Code","Dimension Code");
    AnalysisSelectedDim.SETRANGE("New Dimension Value Code",Code);
    AnalysisSelectedDim.DELETEALL(TRUE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    //IF CheckIfDimValueUsed THEN
    //  ERROR(Text000,GetCheckDimErr);
    #3..23
    */
    //end;


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    RenameBudgEntryDim;
    RenameAnalysisViewEntryDim;
    RenameItemBudgEntryDim;
    RenameItemAnalysisViewEntryDim;

    IF CostAccSetup.GET THEN BEGIN
      CostAccMgt.UpdateCostCenterFromDim(Rec,xRec,3);
      CostAccMgt.UpdateCostObjectFromDim(Rec,xRec,3);
    END;

    SetLastModifiedDateTime;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    #1..4
     {
    #6..9
    {>>>>>>>} ORIGINAL
    {=======} MODIFIED
     }


    SetLastModifiedDateTime;
    {<<<<<<<}
    */
    //end;
}

