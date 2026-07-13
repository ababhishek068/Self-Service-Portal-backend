Report 50250 "Imprest Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ImprestRegister.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Imprest Header"; "Imprest Header")
        {
            column(ReportForNavId_1; 1) { }
            column(DatePosted_ImprestHeader; "Imprest Header"."Date Posted") { }
            column(NumberText; NumberText[1]) { }
            column(CompanyInformationPicture; CompanyInformation.Picture) { }
            column(Date_ImprestHeader; "Imprest Header".Date) { }
            column(TimePosted_ImprestHeader; "Imprest Header"."Time Posted") { }
            column(TotalNetAmountLCY_ImprestHeader; "Imprest Header"."Total Net Amount LCY") { }
            column(Total_Net_Amount; "Total Net Amount") { }
            column(Payee_ImprestHeader; "Imprest Header".Payee) { }
            column(No_ImprestHeader; "Imprest Header"."No.") { }
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoAddress; CompanyInfo.Address) { }
            column(ShortcutDimension2Code_ImprestHeader; "Imprest Header"."Shortcut Dimension 2 Code") { }
            column(GlobalDimension1Code_ImprestHeader; "Imprest Header"."Global Dimension 1 Code") { }
            column(CompanyInfoAddress2; CompanyInfo."Address 2") { }
            column(PostCode; CompanyInfo."Post Code") { }
            column(EMail; CompanyInfo."E-Mail") { }
            column(VATRegistrationNo; CompanyInfo."VAT Registration No.") { }
            column(HomePage; CompanyInfo."Home Page") { }
            column(BankName_ImprestHeader; "Imprest Header"."Bank Name") { }
            column(PayingBankAccount_ImprestHeader; "Imprest Header"."Paying Bank Account") { }
            column(Account_No_ImprestHeader; "Imprest Header"."Account No.") { }
            column(City; CompanyInfo.City) { }
            column(StaffClaimDocNo; StaffClaimDocNo) { }
            column(ChequeNo_ImprestHeader; "Imprest Header"."Cheque No.") { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            dataitem("Imprest Surrender Header"; "Imprest Surrender Header")
            {
                DataItemLink = "Imprest Issue Doc. No" = field("No.");
                column(ReportForNavId_2; 2) { }
                column(Surrender_No; No) { }
                column(Account_No_; "Account No.") { }
                column(Account_Name; "Account Name") { }
                column(Amount_Surrendered_LCY; "Amount Surrendered LCY") { }
                column(Actual_Spent; "Actual Spent") { }
                column(Cash_Surrender_Amt; "Cash Surrender Amt") { }
                column(Difference_Owed; "Difference Owed") { }
                column(Amount; Amount) { }
                column(Net_Amount; "Net Amount") { }
                column(Surrender_Date; "Surrender Date") { }
                column(Totals; Totals) { }

                trigger OnAfterGetRecord()
                begin
                    //Totals:=0;
                    Totals := Totals + "Imprest Header"."Total Net Amount";
                end;
            }
            dataitem("Staff Claims Header"; "Staff Claims Header")
            {
                DataItemLink = "Imprest Doc No" = field("No.");

                column(Staff_Claims_No; "No.") { }
                column(Staff_Claims__Date; Date) { }

            }


            trigger OnAfterGetRecord()
            var
                StaffClaim: Record "Staff Claims Header";
            begin
                StaffClaimDocNo := '';
                CalcFields("Total Net Amount");

                // 
                // CheckReport.FormatNoText(NumberText, ("Total Net Amount"), '');
                CheckReport.FormatNoText(NumberText, "Total Net Amount", 0, ''); // TODO: Check if this Conversion  of amount ot text is correct, as the original code had a different format.
                //ChkTransMgt.FormatNoText(DescriptionLine, CheckLedgEntry.Amount, CheckLanguage, BankAcc2."Currency Code")
                StaffClaim.Reset();
                StaffClaim.SetRange("Imprest Doc No", "No.");
                if StaffClaim.Find('-') then
                    StaffClaimDocNo := StaffClaim."No.";
            end;

            trigger OnPreDataItem()
            begin

            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        CheckReport: Report "Check Translation Management";
        NumberText: array[2] of Text[80];
        CompanyInfo: Record "Company Information";
        Totals: Decimal;
        StaffClaimDocNo: Code[20];
}

