Page 50925 "Hr My Approved Leaves List"
{
    Caption = 'My Approved Leaves';
    CardPageID = "HR My Approved Leaves (Header)";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HR Leave Requisition";
    SourceTableView = where(Status = filter(= Posted));
    ApplicationArea = All;

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
                        Report.Run(70135036, true, true, Rec);
                        Rec.Reset;
                    end;
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
        /*
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
        */
        Rec.SetFilter("User ID", UserId);
        UpdateControls;

    end;

    var
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
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

