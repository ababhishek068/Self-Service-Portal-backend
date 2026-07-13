page 50607 "HR TNA Card"
{
    DeleteAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions,Show';
    SourceTable = "HR Training Needs Analysis";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    Editable = "Application NoEditable";
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
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
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(Directorate; Rec.Directorate)
                {
                    Editable = "Employee DepartmentEditable";
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Directorate field.';
                }
                field("Directorate Name"; Rec."Directorate Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Directorate Name field.';
                }

                field(Department; Rec.Department)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part("TNA Application Lines"; "TNA Application Lines")
            {
                SubPageLink = Code = field(Code);
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
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Disciplinary Approvals","Activity Approval","Exit Approval","Medical Claim Approval",Jv,"BackToOffice ","Training Needs";
                    begin
                        DocumentType := DocumentType::"Training Needs";

                        //ApprovalComments.SetRecordFilters(DATABASE::"HR Training Needs Analysis",DocumentType,Code);
                        //ApprovalComments.SetUpLine(DATABASE::"HR Training Needs Analysis",DocumentType,Code);
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
                    RunPageLink = "Training Code" = FIELD(Code);
                    ToolTip = 'Executes the Training Participants action.';
                }
                action("Training Cost Elements")
                {
                    Caption = 'Training Cost Elements';
                    Image = CalculateCost;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HR Training Cost";
                    RunPageLink = "Training Id" = FIELD(Code);
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
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Disciplinary Approvals","Activity Approval","Exit Approval","Medical Claim Approval",Jv,"BackToOffice ","Training Needs";
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType := DocumentType::"Training Needs";
                        ApprovalEntries.SetRecordFilters(DATABASE::"HR Training Needs Analysis", DocumentType, Rec.Code);
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
                        if Rec."Training category" = Rec."Training category"::Group then
                            if (Rec."No of Participants" < 2) then begin
                                Error('Participants should not be less than two');
                                if (Rec."No of Participants" > Rec."No of Required Participants") then begin
                                    Error('Nominated Participants cannot exceed the Number of Participants Required ');
                                end;
                                if (Rec."No of Participants" <= 0) then begin
                                    Error('Nominated Participants cannot be Less Than or Equal to Zero');
                                end;
                            end;
                        if Confirm('Send this Application for Approval?', true) = false then exit;
                        //ApprovalMgt.SendTNAApprovalRequest(Rec);
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
                        //ApprovalMgt.CancelTNAApprovalReq(Rec,TRUE,TRUE);
                    end;
                }
                action("&Print")
                {
                    Caption = '&Print';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the &Print action.';

                    trigger OnAction()
                    begin
                        //TestField(Status, Status::Approved);
                        HRTNA.SetRange(HRTNA.Code, Rec.Code);
                        if HRTNA.Find('-') then
                            REPORT.Run(Report::"TNA Application Report", true, true, HRTNA);
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

        if Rec."Training category" = Rec."Training category"::Group then begin
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
        HRTNA: Record "HR Training Needs Analysis";
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
        Rec.TestField(Description);
        Rec.TestField("Proposed Start Date");
        Rec.TestField("Proposed End Date");
        //TESTFIELD("Duration Units");
        Rec.TestField(Duration);
        Rec.TestField("Cost Of Training");
        Rec.TestField(Location);
        Rec.TestField("Course Version Description");
        //TESTFIELD("Individual Course");
        Rec.TestField("Need Source")
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

