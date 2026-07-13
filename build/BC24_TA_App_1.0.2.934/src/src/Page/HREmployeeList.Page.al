page 50320 "HR Employee List"
{

    ApplicationArea = All;
    Caption = ' HR Employees';
    PageType = List;
    Editable = true;
    PromotedActionCategories = 'New,Process,Report,Functions';
    SourceTable = "HR-Employee";
    UsageCategory = Lists;
    DeleteAllowed=false;
    CardPageId = "Employee";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Payroll No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }

                field("Old Staff No."; Rec."Old Staff No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Old Staff No. field.';
                }

                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field("Employee Types"; Rec."Employee Types")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee Types field.';
                }

                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Full Name field.';
                }

                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Job Title field.';
                }
                field(Driver;Driver){}
                field("Driving Licence";"Driving Licence"){}
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }

                field("Salary Incremental Month"; Rec."Salary Incremental Month")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Salary Incremental Month field.';
                }

                field("New Basic Pay"; Rec."New Basic Pay")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the New Basic Pay field.';
                }
                field("NHIF No."; Rec."NHIF No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the NHIF No. field.';
                    Visible = false;
                }
                field("Pension No."; Rec."Pension No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pension No. field.';
                    Visible = false;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("TIN No."; Rec."TIN No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';
                }

                field("From IPPD"; Rec."From IPPD")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the From IPPD field.';
                }

                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }

                field("Branch Name"; Rec."Branch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Branch Name field.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            


        }
        

    }
    var
    promotions: Record HR_Promotion;
    noofdaysworked:integer;
    yearlength: Integer;
    hrleavecal: Record "HR Leave Calendar";
    hrstartdate: date;
    hrenddate: date;
    empactive: Boolean;
    hremps: Record "HR-Employee";

    trigger OnAfterGetRecord()
    begin
        if rec.Status=rec.Status::Active then
         if rec."Resignation Date"<>0D then begin
        if rec."Resignation Date"<today then begin
            rec.Status:=rec.Status::InActive;
            rec.modify;
            //CurrPage.Update();
        end;
        end;
        noofdaysworked:=0;
        yearlength:=365;
        hrstartdate:=0D;
        hrenddate:=0D;
        empactive:=false;
        hremps.Reset();
        hremps.SetRange(hremps."No.",rec."No.");
        if hremps.FindFirst() then begin
            if hremps.Status=hremps.Status::Active then begin
                empactive:=true;
            end;
        end;
        hrleavecal.Reset();
        hrleavecal.SetRange(hrleavecal.Current,true);
        if hrleavecal.FindFirst() then begin
            if (hrleavecal."Start Date"<>0D) and (hrleavecal."End Date"<>0D) then begin
                hrstartdate:=hrleavecal."Start Date";
                hrenddate:=hrleavecal."End Date";
            end else begin

            end;
        end else begin

        end;
        if empactive=true then begin
            if rec."Date Of Joining the Company"<hrstartdate then begin
                noofdaysworked:=(Today-hrstartdate)+1;
                rec."No of Worked Days":=noofdaysworked;
                rec.Modify;

            end else if rec."Date Of Joining the Company">=hrstartdate then begin
                noofdaysworked:=(Today-rec."Date Of Joining the Company")+1;
                rec."No of Worked Days":=noofdaysworked;
                rec.Modify;

            end;

        end else if empactive=false then begin
            if rec."Date Of Leaving the Company"<>0D then begin
                noofdaysworked:=rec."Date Of Leaving the Company"-hrstartdate;
                rec."No of Worked Days":=noofdaysworked;
                rec.Modify;
            end;

        end;


        rec.CalcFields("Leave Balance");
        rec.CalcFields("Basic Pay");
        if (rec."Leave Balance"<>0) and (rec."Basic Pay"<>0) then begin 
                         
                if noofdaysworked<>0 then
                rec."Earned Leave Days":=(noofdaysworked/360)*rec."Leave Balance";
                rec.modify; 
                Sleep(10);
                rec."Leave in Birr":=((rec."Basic Pay"*12)/360)*rec."Earned Leave Days";
                rec.Modify;
        end;

        if rec."Cost Share Outstanding Balance"<>0 then begin
            rec.CalcFields("CostShare Contributions");
            rec.Validate("CostShare Contributions");
            if rec."CostShare Balance"<> 0 then begin
                rec."Cost Share?":=true;
                rec.modify;

            end else if rec."CostShare Balance"=0 then begin
                rec."Cost Share?":=false;
                rec.Modify;

            end;

            
        end;
        // if rec.Status=rec.Status::Active then
        // Clear(rec.Transfered);
        // Clear(rec.Promoted);
        // clear(rec.Demoted);
        // clear(rec."Demotion/Transfer/Promotion Date");

        // promotions.Reset();
        // promotions.SetRange(promotions.Employee_No,"No.");
        // promotions.SetRange(promotions.posted,true);
        // promotions.SetRange(promotions.Status,promotions.Status::Approved);
        // if promotions.FindLast() then begin
        //     if promotions.type=promotions.type::Transfer then begin
        //         rec.Transfered:=true;
        //         rec."Demotion/Transfer/Promotion Date":=promotions."New Position Start Date";
        //         rec."Reason for tran/demo/pro":=promotions."Reason Description";
        //         //rec.Modify;
        //     end else if promotions.type=promotions.type::Demotion then begin
        //         rec.Demoted:=true;
        //         rec."Demotion/Transfer/Promotion Date":=promotions."New Position Start Date";
        //         rec."Reason for tran/demo/pro":=promotions."Reason Description";
        //         //rec.modify;

        //     end else if promotions.type=promotions.type::Promotion then begin
        //         rec.Promoted:=true;
        //         rec."Demotion/Transfer/Promotion Date":=promotions."New Position Start Date";
        //         rec."Reason for tran/demo/pro":=promotions."Reason Description";
        //         //rec.modify;
        //     end;


        // end;

        
    end;

    trigger OnOpenPage()
    begin
        // PRPayrollRights.Reset();
        // PRPayrollRights.SetRange("User ID", UserId());
        // PRPayrollRights.SetRange(Authorized, true);
        // if PRPayrollRights.IsEmpty() then begin
        //     //Error('You are not authorized to access this page. Please contact HR department');
        // end;
       
    end;
    var
   
}