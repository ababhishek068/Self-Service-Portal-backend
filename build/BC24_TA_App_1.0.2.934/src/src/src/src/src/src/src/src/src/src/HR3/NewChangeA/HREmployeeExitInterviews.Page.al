page 51334 "HR Employee Exit Interviews"
{
    // version HRMIS 2015 VRS1.0

    DeleteAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Exit Interview';
    SourceTable = "HR Employee Exit Interviews 2";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Exit Interview No"; Rec."Exit Interview No")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Exit Interview No field.';
                }
                field("Date Of Interview"; Rec."Date Of Interview")
                {
                    ToolTip = 'Specifies the value of the Date Of Interview field.';
                }
                field("Interview Done By"; Rec."Interview Done By")
                {
                    ToolTip = 'Specifies the value of the Interview Done By field.';
                }
                field("Interviewer Name"; Rec."Interviewer Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Interviewer Name field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Reason For Leaving"; Rec."Reason For Leaving")
                {
                    ToolTip = 'Specifies the value of the Reason For Leaving field.';
                }
                field("Reason For Leaving (Other)"; Rec."Reason For Leaving (Other)")
                {
                    ToolTip = 'Specifies the value of the Reason For Leaving (Other) field.';
                }
                field("Date Of Leaving"; Rec."Date Of Leaving")
                {
                    ToolTip = 'Specifies the value of the Date Of Leaving field.';
                }
                field(DService; DService)
                {
                    Caption = 'Length of Service';
                    ToolTip = 'Specifies the value of the Length of Service field.';
                }
                field("Reasons for Resignation"; Rec."Reasons for Resignation")
                {
                    Caption = 'why you have resigned from the Authority?';
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the why you have resigned from the Authority? field.';
                }
                field(Dislikes; Rec.Dislikes)
                {
                    Caption = 'Three things which you disliked most about the Authority.';
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Three things which you disliked most about the Authority. field.';
                }
                field(Likes; Rec.Likes)
                {
                    Caption = 'Three things which you most liked about the Authority.';
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Three things which you most liked about the Authority. field.';
                }
                field(Improvements; Rec.Improvements)
                {
                    Caption = 'Three Immediate Improvements';
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Three Immediate Improvements field.';
                }
                field(Opportunities; Rec.Opportunities)
                {
                    Caption = 'Opportunities';
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Opportunities field.';
                }
                field(Comment; Rec.Comment)
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Form Submitted"; Rec."Form Submitted")
                {
                    ToolTip = 'Specifies the value of the Form Submitted field.';
                }
            }
            // part(SF; "Misc. Article Information List")
            // {
            //     Caption = 'Allocated Assets';
            //     SubPageLink = Employee No.=FIELD(Employee No.);
            //         SubPageView = WHERE(In Use=FILTER(Yes));
            // }
        }
        area(factboxes) { }
    }

    actions
    {
        area(navigation)
        {
            group("&Exit Interview")
            {
                Caption = '&Exit Interview';
                action("Close Interview")
                {
                    Image = ClearLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Close Interview action.';

                    trigger OnAction();
                    var
                        HRSetup: Record "HR Setup";
                    begin
                        Rec.TESTFIELD("Form Submitted");
                        HRSetup.get;
                        HRSetup.TestField("HR Admin Address");
                        IF CONFIRM(Text001, TRUE) = FALSE THEN EXIT;

                        HREmp.RESET;
                        HREmp.SETRANGE(HREmp."No.", Rec."Employee No.");
                        IF HREmp.FIND('-') THEN BEGIN
                            HREmp."Date Of Leaving" := Rec."Date Of Leaving";
                            HREmp."Termination Category" := Rec."Reason For Leaving";
                            HREmp."Exit Interview Date" := Rec."Date Of Interview";
                            HREmp."Exit Interview Done by" := Rec."Interview Done By";
                            //   HREmp."Allow Re-Employment In Future":="Re Employ In Future";
                            HREmp.Status := HREmp.Status::InActive;
                            HREmp.MODIFY;
                            Rec.Closed := TRUE;
                            Rec."Exit status" := Rec."Exit status"::Effected;
                            SendApprovalEmail(Rec."Exit Interview No", Rec."Employee Name", Rec.UserID, HRSetup."HR Admin Address");
                            //MESSAGE(Text002);

                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        /*
       IF HREmp.GET(Dependants) THEN BEGIN
       JobTitle:=HREmp."Job Title";
       sUserID:=HREmp."User ID";
       END ELSE BEGIN
       JobTitle:='';
       sUserID:='';
       END;


       SETRANGE(Dependants);
       DAge:='';
       DService:='';
       DPension:='';
       DMedical:='';
       */
        //RecalcDates;
        IF (HREmp."Date of First Appointment" <> 0D) THEN
            DService := Dates.DetermineAge(HREmp."Date of First Appointment", TODAY);

        //UpdateControls;

    end;

    trigger OnOpenPage();
    begin
        UpdateControls;
    end;

    var
        HREmp: Record "hr-employee";
        Dates: Codeunit "HR Codeunit";

        DAge: Text[100];
        DPension: Text[100];
        DMedical: Text[100];

        Text001: Label 'Closing this interview will deactivate the employee. Do you want to continue?';
        DService: Text[150];

    procedure RecalcDates();
    begin
        //Recalculate Important Dates
        IF (HREmp."Date Of Leaving" = 0D) THEN BEGIN
            IF (HREmp."Date Of Birth" <> 0D) THEN
                DAge := Dates.DetermineAge(HREmp."Date Of Birth", TODAY);
            IF (HREmp."Date of First Appointment" <> 0D) THEN
                DService := Dates.DetermineAge(HREmp."Date of First Appointment", TODAY);
            IF (HREmp."Pension Scheme Join" <> 0D) THEN
                DPension := Dates.DetermineAge(HREmp."Pension Scheme Join", TODAY);
            IF (HREmp."Medical Scheme Join" <> 0D) THEN
                DMedical := Dates.DetermineAge(HREmp."Medical Scheme Join", TODAY);
            //MODIFY;
        END ELSE BEGIN
            IF (HREmp."Date Of Birth" <> 0D) THEN
                DAge := Dates.DetermineAge(HREmp."Date Of Birth", HREmp."Date Of Leaving");
            IF (HREmp."Date of First Appointment" <> 0D) THEN
                DService := Dates.DetermineAge(HREmp."Date of First Appointment", HREmp."Date Of Leaving");
            MESSAGE(FORMAT(DService));
            IF (HREmp."Pension Scheme Join" <> 0D) THEN
                DPension := Dates.DetermineAge(HREmp."Pension Scheme Join", HREmp."Date Of Leaving");
            IF (HREmp."Medical Scheme Join" <> 0D) THEN
                DMedical := Dates.DetermineAge(HREmp."Medical Scheme Join", HREmp."Date Of Leaving");
            //MODIFY;
        END;
    end;

    local procedure EmployeeNoOnAfterValidate();
    begin
        /*
       CurrPage.SAVERECORD;
       FILTERGROUP := 2;
       //Misc.SETRANGE(Misc."Employee No.",Dependants);
       FILTERGROUP := 0;
       IF Misc.FIND('-') THEN;
       CurrPage.UPDATE(FALSE);
         */

    end;

    procedure UpdateControls();
    begin
        IF Rec.Closed THEN BEGIN
            CurrPage.EDITABLE := FALSE;
        END ELSE BEGIN
            CurrPage.EDITABLE := TRUE;
        END;
    end;

    procedure SendApprovalEmail(DocNo: Code[20]; Description: Text; User: Code[50]; Receiver: text[200]);
    var
        SMTPMail: Codeunit "Email Message";
        SendEmail: codeunit email;
        SendToList: List of [Text];
        UserSetup: Record "User Setup";
        CompanyInfo: Record "Company Information";
        ReceipAdd: List of [Text];
    begin
        //CLEAR(SMTP);
        UserSetup.GET(User);
        CompanyInfo.GET;
        ReceipAdd.Add(Receiver);
        SMTPMail.Create(SendToList, COMPANYNAME, 'TEST', true);
        // SMTPMail.Create(COMPANYNAME, CompanyInfo."E-Mail", ReceipAdd,
        //'This is to inform you that: ' + DocNo, 'Employee Number ' + ' ' + DocNo + ' has  ' + Description + ' Effective from. ' + FORMAT("Date Of Leaving")
        //, TRUE);
        //  SMTPMail.AppendBody('<br>');
        SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);
    end;
}

