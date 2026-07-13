
Page 51534 "Overtime Card."
{
    PageType = Card;
    SourceTable = "Overtime Header-ta";
    ApplicationArea=all;


    layout
    {
        area(content)
        {
            group(General)
            {
                field("Overtime ID";"Overtime ID")
                {
                    ApplicationArea = Basic;
                    Editable=false;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Visible=false;
                }
                field("Total Amount";"Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount(LCY)";"Total Amount(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Period Month";"Period Month")
                {
                    ApplicationArea = Basic;
                }
                field("Period Year";"Period Year")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Period";"Payroll Period")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Code";"Payroll Code")
                {
                    ApplicationArea = Basic;
                }
                field("Job Group";"Job Group")
                {
                    ApplicationArea = Basic;
                    Visible=false;
                }
                field("Approve for Payroll";"Approve for Payroll"){}
                field("Created By";"Created By"){}
                field("Created on";"Created on"){}
                field("Posted By";"Posted By"){}
                field("Date Posted";"Date Posted"){}
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
            }
            part(overtimelist; "Overtime Line List")
            {
                SubPageLink=PayrollPeriod=field("Payroll Period");
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(ActionGroup1120054014)
            {
                action("Approve for Payroll")
                {
                    ApplicationArea = Basic;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                    ask:Boolean;
                    begin
                         payrollperiod.Reset();
                         payrollperiod.SetRange(payrollperiod."Date Opened","Payroll Period");
                         payrollperiod.SetRange(payrollperiod.Closed,false);
                         if payrollperiod.FindFirst() then begin
                            if Posted=true then begin
                          Error('Already posted');
                            //Updateearnings();
                            //Posted:=true;
                        end else if Posted=false then begin
                            if "Approve for Payroll"=true then begin
                                Error('Already released for payroll');

                            end else if "Approve for Payroll"=false then begin
                                ask:=Confirm('Are you sure the records are correct and you want to update the payroll? If yes, you cannot modify after.');
                                if ask=true then begin
                                    Updateearnings();
                                    
                                    Message('records send to payroll succesfully, they will be processed for current payroll period');
                                end;

                            end;
                        end;
                            

                         end else if not payrollperiod.find() then begin

                        Error('Payroll period closed, please try for the next payroll period');
                         end;
                        
                        //TESTFIELD(Posted,FALSE);
                        
                    end;
                }
            }
        }
    }

    var
        overtimeLines: Record "Overtime Lines";
        payrollperiod: Record "PR Payroll Periods";

    procedure Updateearnings()
    var
        Earnings: Record "PR Employee Transactions";
        vitalsetup: Record "PR Vital Setup Info";
        salcard: Record "PR Salary Card";
    begin
        vitalsetup.Get();
        if vitalsetup."Overtime Code"<>'' then begin
            //Message(vitalsetup."Overtime Code");
            overtimeLines.Reset();
            //overtimeLines.SetRange(overtimeLines.OvertimeID, rec."Overtime ID");
            overtimeLines.SetRange(overtimeLines.PayrollPeriod,rec."Payroll Period");
            if overtimeLines.Find('-') then begin
               // Message(overtimeLines."Employee code");
                repeat
                if overtimeLines."Line Total"<>0 then begin
                    Message(format(overtimeLines."Line Total"));
                    Earnings.Reset();
                    Earnings.SetRange(Earnings."Transaction Code",vitalsetup."Overtime Code");
                    Earnings.SetRange(Earnings."Payroll Period",rec."Payroll Period");
                    Earnings.SetRange(Earnings."Employee Code",overtimeLines."Employee code");
                    if Earnings.Find('-') then begin 
                        Earnings.Amount:=overtimeLines."Line Total";
                    end else if not Earnings.Find() then  begin
                        Earnings.Init;
                        Earnings."Transaction Code":=vitalsetup."Overtime Code";
                        Earnings.Validate("Transaction Code");
                        Earnings."Payroll Period":=rec."Payroll Period";
                        Earnings."Period Month":=rec."Period Month";
                        Earnings."Period Year":=rec."Period Year";
                        Earnings."Employee Code":=overtimeLines."Employee code";
                        Earnings.Amount:=overtimeLines."Line Total";
                        Earnings.Insert;
                    end;


                end;

                until overtimeLines.next=0;
                rec."Approve for Payroll":=true;
                                    rec.Posted:=true;
                                    rec."Date Posted":=Today;
                                    rec."Posted By":=UserId;
                                    rec.Modify();
            end;

            end;


        end;
          
   
    trigger OnModifyRecord(): Boolean
    begin
        if "Approve for Payroll"=true then begin
            Error('You cannot modify this record');



        end;
    end;
}


