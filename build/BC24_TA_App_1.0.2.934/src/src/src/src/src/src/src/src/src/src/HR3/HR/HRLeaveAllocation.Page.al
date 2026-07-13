Page 50728 "HR Leave Allocation"
{
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "HR Leave Allocation";
    SourceTableView = where(Posted = const(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PostedBy; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(PostingType; Rec."Posting Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Type field.';
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Leave Posting Description field.';
                }
                field(CalendarCode; Rec."Calendar Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Calendar Code field.';
                }
                field(CalendarStartDate; Rec."Calendar Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Calendar Start Date field.';
                }
                field(CalendarEndDate; Rec."Calendar End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Calendar End Date field.';
                }
                field(LeaveType; Rec."Leave Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Leave Type field.';
                }
                field(StaffNo; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(StaffName; Rec."Staff Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff Name field.';
                }
                field(NoOfdays; Rec."No. Of days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Of days field.';
                    // Editable = true;
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000016; Notes) { }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                action("Post Adjustment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Adjustment';
                    Image = PostedTaxInvoice;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Post Adjustment action.';

                    trigger OnAction()
                    var
                        CNF_POST_LEAVE_001: label 'Post Leave Batch with [ %1 ] Entries?';
                    begin
                        HRLeaveAllocation.Reset;
                        HRLeaveAllocation.SetRange(Posted, false);
                        if HRLeaveAllocation.FindSet then begin
                            CounterVar := HRLeaveAllocation.Count;
                            if Confirm(CNF_POST_LEAVE_001, false, HRLeaveAllocation.Count) = false then Error('Process Aborted');
                            repeat
                                HRLeaveAllocation."Posted By" := UserId;
                                HRLeaveAllocation.Posted := true;
                                HRLeaveAllocation.Closed := false;
                                HRLeaveAllocation.Modify;
                                Postentries.PostLeaveAllocation(HRLeaveAllocation."Entry No.", HRLeaveAllocation."No.", HRLeaveAllocation."Leave Type", HRLeaveAllocation."Calendar Code");
                            until HRLeaveAllocation.Next = 0;
                        end;

                        Message('%1 Entries Posted', CounterVar);
                    end;
                }
                action("Batch Allocation")
                {
                    ApplicationArea = Basic;
                    Image = CalculatePlanChange;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Report "HR Leave Adjustments";
                    ToolTip = 'Executes the Batch Allocation action.';
                }

                action(ClearAllocationBatch)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Clear Leave Batch';
                    Image = DeleteRow;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Clear Leave Batch action.';

                    trigger OnAction()
                    var
                        HRLeaveAllocation: Record "HR Leave Allocation";
                    begin
                        HRLeaveAllocation.Reset();
                        HRLeaveAllocation.SetRange(Posted, false);
                        if not HRLeaveAllocation.IsEmpty() then HRLeaveAllocation.DeleteAll();
                    end;
                }

            }
        }
    }

    var
        HRLeaveAllocation: Record "HR Leave Allocation";
        CounterVar: Integer;
        Postentries: Codeunit "HR Post Leave Journal Ent.";
}

