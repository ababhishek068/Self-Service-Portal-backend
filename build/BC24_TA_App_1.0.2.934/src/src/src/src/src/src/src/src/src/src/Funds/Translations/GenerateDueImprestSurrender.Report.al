report 50339 "Generate Due Imprest Surrender"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Imprest Lines"; "Imprest Lines")
        {
            DataItemTableView = where("Surrender Count" = filter(0), "Posted to Payroll" = filter(false));
            RequestFilterFields = "Due Date", "Imprest Holder";
            trigger OnPreDataItem()
            begin
                "Imprest Lines".setfilter("Due Date", '<%1', today);
                GenSetup.get;
                prPeriods.reset;
                prPeriods.setrange(Closed, false);
                if prPeriods.find('-') then
                    currPeriod := prPeriods."Date Opened";
            end;

            trigger OnAfterGetRecord()
            var
                Cust: Record Customer;
                Billing: Codeunit HRWebportal;

            begin
                if "Imprest Lines"."Due Date" < today then begin
                    cust.get("Imprest Lines"."Imprest Holder");

                    if ("Imprest Lines"."Due Date" > today) and ("Imprest Lines"."Posted to Payroll" = false) then begin
                        if gensetup."Auto Post Due Imprest to Payroll" = true then begin
                            prTrans.reset;
                            prTrans.setrange("Imprest Surrender", true);
                            if prTrans.find('-') then begin
                                UserRec.reset;
                                UserRec.setrange(UserRec."Staff Travel Account", "Imprest Lines"."Imprest Holder");
                                if UserRec.find('-') then begin
                                    prPeriods.reset;
                                    prPeriods.setrange("Date Opened", currPeriod);
                                    if prPeriods.find('-') then begin
                                        EmpTrans.init;
                                        EmpTrans."Employee Code" := UserRec."Employee No.";
                                        EmpTrans.Amount := "Imprest Lines".Amount;
                                        EmpTrans."Transaction Code" := prTrans."Transaction Code";
                                        EmpTrans."Transaction Name" := prTrans."Transaction Name";
                                        EmpTrans."Payroll Period" := currPeriod;
                                        EmpTrans."Period Month" := prPeriods."Period Month";
                                        EmpTrans."Period Year" := prPeriods."Period Year";
                                        EmpTrans."Reference No" := "Imprest Lines".No;
                                        EmpTrans.insert;
                                    end;
                                end;
                            end;
                            "Imprest Lines"."Posted to Payroll" := true;

                        end;

                    end;
                    if GenSetup."Notify On Imprest Surrender" = true then begin
                        if ("Imprest Lines"."Due Date" - today > 0) and ("Imprest Lines"."Due Date" - today < 8) and (today - "Imprest Lines"."Last Notiff date" > 6) then begin
                            if Cust."E-Mail" <> '' then
                                if Billing.SendEmail(cust."E-Mail", 'ImprestSurrender Reminder', 'Dear ' + Cust.Name + ' Please note that your Imprest Number ' + "Imprest Lines".No + ' will be due for surender on ' + format("Imprest Lines"."Due Date")) then
                                    "Imprest Lines"."Last Notiff date" := today;
                        end;

                    end;
                end;
                "Imprest Lines".Modify();
            end;

        }

    }




    var
        GenSetup: Record "Cash Office Setup";
        prTrans: Record "pr Transaction Codes";
        EmpTrans: record "PR Employee Transactions";
        prPeriods: Record "pr Payroll Periods";
        currPeriod: date;
        UserRec: Record "User Setup";
}