Page 50923 "Hr Emp. Leave Journal Lines"
{
    PageType = List;
    SourceTable = "HR Employee Leave Journal";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(StaffNo; Rec."Staff No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff No. field.';
                }
                field(StaffName; Rec."Staff Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Staff Name field.';
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(TransactionDescription; Rec."Transaction Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Description field.';
                }
                field(LeaveType; Rec."Leave Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Leave Type field.';
                }
                field(NoofDays; Rec."No. of Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. of Days field.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field(LeaveBalancePrevYear; Rec."Leave Balance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Balance Prev. Year';
                    ToolTip = 'Specifies the value of the Leave Balance Prev. Year field.';
                }
                field(AllowCarryForward; Rec."Allow Carry Forward")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Carry Forward field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(GetAnnual_Leave)
            {
                ApplicationArea = Basic;
                Caption = 'Get Annual Leave Allocations';
                Image = GetLines;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Get Annual Leave Allocations action.';

                trigger OnAction()
                begin
                    if Confirm('Generate annual Leave allocations?', true) = false then exit;
                    Clear(ints);

                    leaveJournal.Reset;
                    if leaveJournal.Find('-') then
                        leaveJournal.DeleteAll;

                    hremployee.Reset;
                    hremployee.SetRange(hremployee.Status, hremployee.Status::Active);
                    if hremployee.Find('-') then begin
                        // Populate leave journal with
                        repeat
                        begin
                            if ((hremployee."Salary Grade" <> 0) and (hremployee."Salary Grade" <> 0)) then begin
                                salaryGrades.Reset;
                                salaryGrades.SetRange(salaryGrades."Employee Category", hremployee."Job Group");
                                salaryGrades.SetRange(salaryGrades."Salary Grade code", hremployee.Grade);
                                if salaryGrades.Find('-') then begin
                                    if salaryGrades."Annual Leave Days" <> 0 then begin

                                        "Days Allocated" := salaryGrades."Annual Leave Days";
                                        /*
                                                                                if "Days Allocated" > 0 then begin
                                                                                    //check if the leave extension requisition has been raised and approved
                                                                                    staffReq.Reset;
                                                                                    staffReq.SetRange(staffReq.RequisitionType, staffReq.Requisitiontype::"Leave Extension Requisition");
                                                                                    staffReq.SetRange(staffReq.Status, staffReq.Status::Approved);
                                                                                    staffReq.SetRange(staffReq."Employee No", hremployee."No.");
                                                                                    if staffReq.Find('-') then begin
                                                                                        "Days Allocated" := "Days Allocated" + staffReq."Applied Days";
                                                                                    end;
                                                                                end;
                                        */
                                        // populate the Journal
                                        leaveledger.Reset;
                                        leaveledger.SetRange(leaveledger."Document No", hremployee."No.");
                                        leaveledger.SetRange(leaveledger."Leave Period", Date2dmy(Today, 3));
                                        leaveledger.SetFilter(leaveledger."Entry Type", '<>%1', leaveledger."entry type"::Allocation);
                                        //IF not leaveledger.FIND('-') THEN BEGIN

                                        // Insert the Journals
                                        // Delete Existing Journal Entries first
                                        hremployee.SetFilter(hremployee."Date Filter", '<%1', 20170101D);
                                        hremployee.CalcFields("Leave Balance");
                                        LeaveBal := hremployee."Leave Balance";
                                        ints := ints + 1;
                                        leaveJournal.Init;
                                        leaveJournal."Line No." := ints;
                                        leaveJournal."Staff No." := hremployee."No.";
                                        leaveJournal."Staff Name" := hremployee."First Name" + ' ' + hremployee."Middle Name" + ' ' + hremployee."Last Name";
                                        leaveJournal."Transaction Description" := 'Leave Allocations for ' + Format(Date2dmy(Today, 3));
                                        leaveJournal."Leave Type" := 'ANNUAL';
                                        leaveJournal."No. of Days" := "Days Allocated";
                                        leaveJournal."Transaction Type" := leaveJournal."transaction type"::Allocation;
                                        leaveJournal."Document No." := 'ALL-' + Format(Date2dmy(Today, 3));
                                        leaveJournal."Posting Date" := Today;
                                        leaveJournal."Leave Period" := Date2dmy(Today, 3);
                                        leaveJournal."Leave Balance" := LeaveBal;
                                        leaveJournal.Insert;
                                        //END;

                                    end;
                                end;
                            end;
                        end;
                        until hremployee.Next = 0;
                    end;
                    Message('Annual leave days generated successfully!');
                end;
            }
            action(Post_Leave)
            {
                ApplicationArea = Basic;
                Caption = 'Post Leave Journal';
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Post Leave Journal action.';

                trigger OnAction()
                begin

                    Codeunit.Run(70134686);
                end;
            }
            group(Import)
            {
                Caption = '&Actions';
                action(ImportLeaveBalances)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Leave Balances';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Import Leave Balances action.';

                    trigger OnAction()
                    begin
                        if Confirm('!!!!!!!!!!!!!!!!!!!!....................... IMPORTANT.................!!!!!!!!!!!!!!!!!!!!!!!\' +
                        'Please ensure that your data is saved in ''.CSV'' format i.e. Comma delimeted.' +
                        '\The data should be in the following format:\' +
                        ' Line No|Staff No|Name|Description|Leave Type|No. of Days|Trans Type|Doc. No|Post Date|Leave Period.\' +
                        '\' +
                        '...........................EXAMPLE.........................\' +
                        '1|0001|Wanjala Tom|2015Leave days|ANNUAL|23|ALLOCATION|leave_2015|22012015|2015\' +
                        '2|0002|Jacinta Mwali|2015Leave days|ANNUAL|23|ALLOCATION|leave_2015|22012015|2015\' +
                        '\' +
                        'Continue?', true) = false then
                            Error('Cancelled by user!');

                        Xmlport.Run(70134687, false, true);
                        Message('Imported Successfully!');
                    end;
                }
            }
        }
    }

    var
        salaryGrades: Record "Job_Salary grade/steps";
        hremployee: Record "HR-Employee";
        leaveledger: Record "HR Leave Ledger";
        leaveJournal: Record "HR Employee Leave Journal";
        ints: Integer;
        "Days Allocated": Decimal;
        // staffReq: Record UnknownRecord70134985;
        LeaveBal: Decimal;
}

