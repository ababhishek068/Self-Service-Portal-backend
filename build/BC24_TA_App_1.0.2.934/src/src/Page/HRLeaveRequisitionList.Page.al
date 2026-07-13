Page 50541 "HR Leave Requisition List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = all;
    SourceTable = "HR Leave Requisition";
    SourceTableView = where(Posted = filter(false));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                Editable = false;

                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';

                }
                field(EmployeeNo; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No field.';

                }
                field(EmployeeName; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(AppliedDays; Rec."Applied Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applied Days field.';
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(DepartmentCode; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field(LeaveType; Rec."Leave Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Leave Type field.';
                }
                field(LeaveBalance; Rec."Leave Balance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Leave Balance field.';
                }
                field(ReturnDate; Rec."Return Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Return Date field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Approvals action.';


                    trigger OnAction()
                    begin
                        DocumentType := Documenttype::"Leave Application";
                        ApprovalEntries.SetRecordFilters(Database::"HR Leave Requisition", DocumentType, Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                action(sendApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send A&pproval Request action.';


                    trigger OnAction()
                    var
                        State: Option Open,"Pending Approval",Cancelled,Approved;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                        Rec.TestField("Employee No");
                        Rec.TestField("Applied Days");
                        Rec.TestField("Starting Date");
                        Rec.TestField("Reliever No.");
                        Rec.TestField(Purpose);
                        if Rec."Availlable Days" < 1 then Error('Please note that you dont have enough leave balance');


                        //Release the Imprest for Approval
                        State := State::Open;
                        if Rec.Status <> Rec.Status::Open then State := State::"Pending Approval";
                        DocType := Doctype::"Leave Application";
                        Clear(tableNo);
                        tableNo := 39005550;
                        //IF ApprovalMgt.SendApproval(tableNo,Rec."No.",DocType,State) THEN;
                        //  IF ApprovalMgt.SendLeaveApprovalRequest(Rec) THEN;
                    end;
                }
                action(cancellsApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    var
                        //  ApprovalMgt: Codeunit UnknownCodeunit439;
                        showmessage: Boolean;
                        ManualCancel: Boolean;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                        DocType := Doctype::"Leave Application";
                        showmessage := true;
                        ManualCancel := true;
                        Clear(tableNo);
                        tableNo := 39005550;
                        // if ApprovalMgt.CancelApproval(tableNo, DocType, Rec."No.", showmessage, ManualCancel) then;

                        // IF ApprovalMgt.CancelLeaveApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                separator(Action1102755038) { }
                action(PrintPreview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Image = PrintReport;
                    Promoted = true;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Print/Preview action.';

                    trigger OnAction()
                    begin
                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        Report.Run(70135251, true, true, Rec);
                        Rec.Reset;
                    end;
                }
                separator(Action16) { }
                action("Leave Journal")
                {
                    ApplicationArea = Basic;
                    Image = JobJournal;

                    Promoted = true;
                    RunObject = Page "Hr Emp. Leave Journal Lines";
                    ToolTip = 'Executes the Leave Journal action.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls;
    end;

    trigger OnInit()
    begin
        PurposeEditable := true;
        "Starting DateEditable" := true;
        "Applied DaysEditable" := true;
        "Department CodeEditable" := true;
        "Campus CodeEditable" := true;
        "Employee NoEditable" := true;
        DateEditable := true;
        "No.Editable" := true;
    end;

    trigger OnOpenPage()
    begin

        //  if UserMgt.GetPurchasesFilter() <> '' then begin
        //      FilterGroup(2);
        //      SetRange("Responsibility Center", UserMgt.GetPurchasesFilter());
        //      FilterGroup(0);
        //  end;

        //SETFILTER("User ID",USERID);
        UpdateControls;
    end;

    var
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
        // MinorAssetsIssue: Record UnknownRecord70135013;
        // LeaveEntry: Record UnknownRecord70135277;
        [InDataSet]
        "No.Editable": Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        "Employee NoEditable": Boolean;
        [InDataSet]
        "Campus CodeEditable": Boolean;
        [InDataSet]
        "Department CodeEditable": Boolean;
        [InDataSet]
        "Applied DaysEditable": Boolean;
        [InDataSet]
        "Starting DateEditable": Boolean;
        [InDataSet]
        PurposeEditable: Boolean;
        ApprovalEntries: Page "Approval Entries";

    procedure UpdateControls()
    begin
        if Rec.Status <> Rec.Status::Open then begin
            "No.Editable" := false;
            DateEditable := false;
            "Employee NoEditable" := false;
            "Campus CodeEditable" := false;
            "Department CodeEditable" := false;
            "Applied DaysEditable" := false;
            "Starting DateEditable" := false;
            PurposeEditable := false;
            //  CurrForm."Process Leave Allowance".EDITABLE:=FALSE;
        end else begin
            "No.Editable" := true;
            DateEditable := true;
            "Employee NoEditable" := true;
            "Campus CodeEditable" := true;
            "Department CodeEditable" := true;
            "Applied DaysEditable" := true;
            "Starting DateEditable" := true;
            PurposeEditable := true;
            // CurrForm."Process Leave Allowance".EDITABLE:=TRUE;

        end;
    end;
}

