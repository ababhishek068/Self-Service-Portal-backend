Report 50251 "Food Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FoodReceipt.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Menu Sale Header"; "Menu Sale Header")
        {
            column(ReportForNavId_9620; 9620) { }
            column(Menu_Sale_Header__Sales_Point_; "Sales Point") { }
            column(Reg; Reg) { }
            column(Menu_Sale_Header__Receipt_No_; "Receipt No") { }
            column(Menu_Sale_Header__Paid_Amount_; "Paid Amount") { }
            column(Menu_Sale_Header_Balance; Balance) { }
            column(Menu_Sale_Header__Cashier_Name_; "Cashier Name") { }
            column(CHUKACaption; CHUKACaptionLbl) { }
            column(UNIVERSITYCaption; UNIVERSITYCaptionLbl) { }
            column(CALL_AGAINCaption; CALL_AGAINCaptionLbl) { }
            column(REG_Caption; REG_CaptionLbl) { }
            column(Menu_Sale_Header__Paid_Amount_Caption; FieldCaption("Paid Amount")) { }
            column(PrepBalBef; PrepBalAf) { }
            column(PrepBalAf; PrepBalBef) { }
            column(Secur; SecFo) { }
            column(Menu_Sale_Header_BalanceCaption; FieldCaption(Balance)) { }
            column(SalesType; "Menu Sale Header"."Sales Type") { }
            column(Date_Menu; "Menu Sale Header".Date) { }
            column(CustomerNo; "Menu Sale Header"."Customer No") { }
            dataitem("Menu Sales Line"; "Menu Sales Line")
            {
                DataItemLink = "Receipt No" = field("Receipt No");
                DataItemTableView = sorting("Line No", "Receipt No") order(ascending);
                column(ReportForNavId_8025; 8025) { }
                column(Menu_Sales_Line__Unit_Cost_; "Unit Cost") { }
                column(Menu_Sales_Line_Quantity; Quantity) { }
                column(Menu_Sales_Line_Amount; Amount) { }
                column(Menu_Sales_Line_Description; Description) { }
                column(Menu_Sales_Line_Amount_Control1000000012; Amount) { }
                column(TotalCaption; TotalCaptionLbl) { }
                column(Menu_Sales_Line_Line_No; "Line No") { }
                column(Menu_Sales_Line_Menu; Menu) { }
                column(Menu_Sales_Line_Receipt_No; "Receipt No") { }
            }

            trigger OnAfterGetRecord()
            begin
                "Menu Sale Header".CalcFields("Menu Sale Header"."Prepayment Balance");
                "Menu Sale Header".CalcFields("Menu Sale Header".Amount);
                PrepBalBef := "Menu Sale Header"."Prepayment Balance";
                if PrepBalBef <> 0 then
                    PrepBalAf := "Menu Sale Header"."Prepayment Balance" - "Menu Sale Header".Amount;

                if "Menu Sale Header"."Sales Type" = "Menu Sale Header"."sales type"::BreakFast then begin
                    PrepBalBef := 0;
                    PrepBalAf := 0;
                end;

                Sec := 010101T - Time;
                SecFo := Format(Sec);
                "Menu Sale Header"."Last Sc" := Format(Sec);
                "Menu Sale Header".Modify;
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        Reg: Code[20];
        CHUKACaptionLbl: label 'CHUKA';
        UNIVERSITYCaptionLbl: label 'UNIVERSITY';
        CALL_AGAINCaptionLbl: label 'CALL AGAIN';
        REG_CaptionLbl: label 'REG:';
        TotalCaptionLbl: label 'Total';
        PrepBalBef: Decimal;
        PrepBalAf: Decimal;
        Sec: Integer;
        SecFo: Text;
}

