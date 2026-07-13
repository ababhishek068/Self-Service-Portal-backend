page 51003 "HR Training Application Card"
{
    DeleteAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions,Show';
    SourceTable = "HR Training Applications";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Application No"; Rec."Application No")
                {
                    Editable = "Application NoEditable";
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Application No field.';
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Application Date field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(Supervisor; Rec.Supervisor)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Supervisor field.';
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Supervisor Name field.';
                }
                field("Training Category"; Rec."Training Category")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Training Category field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = "Employee No.Editable";
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Global Dimension 1"; Rec."Global Dimension 1")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 field.';
                }
                field("Global Dimension 2"; Rec."Global Dimension 2")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 field.';
                }

                field(Station; Rec.Station)
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Station field.';
                }
                field("Course Title"; Rec."Course Title")
                {
                    Editable = "Course TitleEditable";
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Course Title field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }

                field("Purpose of Training"; Rec."Purpose of Training")
                {
                    MultiLine = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Purpose of Training field.';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field("Duration Units"; Rec."Duration Units")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Duration Units field.';
                }
                field(Sponsor; Rec.Sponsor)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Sponsor field.';
                }
                field(Specify; Rec.Specify)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Specify field.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Location field.';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field(Region; Rec.Region)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Region field.';
                }
                field("Cost Of Training"; Rec."Cost Of Training")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cost Of Training field.';
                }
                field(Trainer; Rec.Trainer)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Trainer field.';
                }
                field("Training Institution"; Rec."Training Institution")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Training Institution field.';
                }

                field(Status; Rec.Status)
                {
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Training Status"; Rec."Training Status")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Training Status field.';
                }
                field("Training Evaluation Results"; Rec."Training Evaluation Results")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Training Evaluation Results field.';
                }
                field("No of Participants"; Rec."No of Participants")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No of Participants field.';
                }
            }
            group(Participants)
            {
                part(Control1102755004; "HR Training Partcipants")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Employee Code" = FIELD("Employee No.");
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70135040),
                              "No." = FIELD("Application No");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Show")
            {
                Caption = '&Show';
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = Comment;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Comments action.';

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Application","Transport Requisition";
                    begin
                        DocumentType := DocumentType::"Training Application";

                        //ApprovalComments.SetRecordFilters(DATABASE::"HR Training Applications",DocumentType,"Application No");
                        //ApprovalComments.SetUpLine(DATABASE::"HR Training Applications",DocumentType,"Application No");
                        //ApprovalComments.RUN;
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Training Participants")
                {
                    Caption = 'Training Participants';
                    Image = PersonInCharge;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HR Training Partcipants";
                    RunPageLink = "Training Code" = FIELD("Application No");
                    ToolTip = 'Executes the Training Participants action.';
                }
                action("Training Cost Elements")
                {
                    Caption = 'Training Cost Elements';
                    Image = CalculateCost;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HR Training Cost";
                    RunPageLink = "Training Id" = FIELD("Application No");
                    ToolTip = 'Executes the Training Cost Elements action.';
                }
                action("&Approvals")
                {
                    Caption = '&Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the &Approvals action.';

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval";
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType := DocumentType::"Training Requisition";
                        ApprovalEntries.SetRecordFilters(DATABASE::"HR Training Applications", DocumentType, Rec."Application No");
                        ApprovalEntries.Run;
                    end;
                }
                action("&Send Approval &Request")
                {
                    Caption = '&Send Approval &Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the &Send Approval &Request action.';

                    trigger OnAction()
                    begin
                        TESTFIELDS;
                        Rec.CalcFields("No of Participants");
                        if (Rec."No of Participants" < 2) then begin
                            Error('Participants should not be less than two');
                        end;
                        if (Rec."No of Participants" > Rec."No of Required Participants") then begin
                            Error('Nominated Participants cannot exceed the Number of Participants Required ');
                        end;
                        if (Rec."No of Participants" <= 0) then begin
                            Error('Nominated Participants cannot be Less Than or Equal to Zero');
                        end;

                        if Confirm('Send this Application for Approval?', true) = false then exit;
                        //ApprovalMgt.SendTrainingAppApprovalRequest(Rec);
                    end;
                }
                action("&Cancel Approval request")
                {
                    Caption = '&Cancel Approval request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the &Cancel Approval request action.';

                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to cancel the approval request', true) = false then exit;
                        //ApprovalMgt.CancelTrainingAppApprovalReq(Rec,TRUE,TRUE);
                    end;
                }
                action("&Print")
                {
                    Caption = '&Print';
                    ApplicationArea = Basic;
                    Image = Print;
                    ToolTip = 'Executes the &Print action.';
                    trigger OnAction()
                    var
                        HRTraining: Record "HR Training Applications";
                        TRReport: Report "Training Report Card";
                    begin
                        HRTraining.Reset();
                        if HRTraining.Find('-') then begin
                            TRReport.SetTableView(HRTraining);
                            TRReport.Run();

                        end;
                    end;
                }
                action("<A ction1102755042>")
                {
                    Caption = 'Re-Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;
                    ToolTip = 'Executes the Re-Open action.';

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::New;
                        Rec.Modify;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        if Rec.Status = Rec.Status::New then begin
            "Responsibility CenterEditable" := true;
            "Application NoEditable" := true;
            "Employee No.Editable" := true;
            "Employee NameEditable" := true;
            "Employee DepartmentEditable" := true;
            "Purpose of TrainingEditable" := true;
            "Course TitleEditable" := true;
        end else begin
            "Responsibility CenterEditable" := false;
            "Application NoEditable" := false;
            "Employee No.Editable" := false;
            "Employee NameEditable" := false;
            "Employee DepartmentEditable" := false;
            "Purpose of TrainingEditable" := false;
            "Course TitleEditable" := false;
        end;

        if Rec."Training Category" = Rec."Training Category"::Group then begin
            "Course TitleEditable" := true;
        end else begin
            "Course TitleEditable" := false;
        end;
    end;

    trigger OnInit()
    begin
        "Course TitleEditable" := true;
        "Purpose of TrainingEditable" := true;
        "Employee DepartmentEditable" := true;
        "Employee NameEditable" := true;
        "Employee No.Editable" := true;
        "Application NoEditable" := true;
        "Responsibility CenterEditable" := true;
        "Course DescriptionEditable" := true;
        "Course TitleEditable" := true;
    end;

    var
        [InDataSet]

        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        "Application NoEditable": Boolean;
        [InDataSet]
        "Employee No.Editable": Boolean;
        [InDataSet]
        "Employee NameEditable": Boolean;
        [InDataSet]
        "Employee DepartmentEditable": Boolean;
        [InDataSet]
        "Purpose of TrainingEditable": Boolean;
        [InDataSet]
        "Course TitleEditable": Boolean;
        "Course DescriptionEditable": Boolean;

    procedure TESTFIELDS()
    begin
        Rec.TestField("Course Title");
        Rec.TestField("From Date");
        Rec.TestField("To Date");
        Rec.TestField("Duration Units");
        Rec.TestField(Duration);
        Rec.TestField("Cost Of Training");
        Rec.TestField(Location);
        Rec.TestField(Trainer);
        Rec.TestField("Purpose of Training");
        Rec.TestField(Description)
    end;

    procedure UpdateControls()
    begin

        /*IF "Training category"="Training category"::Group THEN BEGIN
        CurrPage.Description.EDITABLE:=TRUE;
        END ELSE BEGIN
        CurrPage.Description.EDITABLE:=FALSE;
        END;
   */

    end;
}

