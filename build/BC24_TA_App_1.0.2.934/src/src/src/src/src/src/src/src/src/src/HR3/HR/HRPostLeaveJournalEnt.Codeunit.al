Codeunit 50017 "HR Post Leave Journal Ent."
{

    trigger OnRun()
    var
        progre: Dialog;
        counts: Integer;
        RecCount1: Text[120];
        RecCount2: Text[120];
        RecCount3: Text[120];
        RecCount4: Text[120];
        RecCount5: Text[120];
        RecCount6: Text[120];
        RecCount7: Text[120];
        RecCount8: Text[120];
        RecCount9: Text[120];
        RecCount10: Text[120];
        BufferString: Text[1024];
        Var1: Code[10];
    begin

        if Confirm('Post Leave Journal Lines?', false) = false then exit;

        hrLeaveJournal.Reset;
        // HrEmployee.SETRANGE(HrEmployee."Employee Type",HrEmployee."Employee Type"::Permanent);
        //HrEmployee.SETRANGE(HrEmployee.Status,HrEmployee.Status::Normal);
        if hrLeaveJournal.Find('-') then begin

            Clear(RecCount1);
            Clear(RecCount2);
            Clear(RecCount3);
            Clear(RecCount4);
            Clear(RecCount5);
            Clear(RecCount6);
            Clear(RecCount7);
            Clear(RecCount8);
            Clear(RecCount9);
            Clear(RecCount10);
            Clear(counts);
            progre.Open('Processing Please wait..............\#1###############################################################' +
            '\#2###############################################################' +
            '\#3###############################################################' +
            '\#4###############################################################' +
            '\#5###############################################################' +
            '\#6###############################################################' +
            '\#7###############################################################' +
            '\#8###############################################################' +
            '\#9###############################################################' +
            '\#10###############################################################' +
            '\#11###############################################################' +
            '\#12###############################################################' +
            '\#13###############################################################',
                RecCount1,
                RecCount2,
                RecCount3,
                RecCount4,
                RecCount5,
                RecCount6,
                RecCount7,
                RecCount8,
                RecCount9,
                RecCount10,
                Var1,
                Var1,
                BufferString
            );
            Clear(lastNo);
            leaveLedger.Reset;
            leaveLedger.SetFilter(leaveLedger."Entry No.", '<>%1', 0);
            if leaveLedger.FindLast then begin
                lastNo := leaveLedger."Entry No." + 10;
            end else
                lastNo := 10;
            repeat
                //Post Leave Journals
                leaveLedger.Init;
                leaveLedger."Entry No." := lastNo;
                leaveLedger."Employee No" := hrLeaveJournal."Staff No.";
                leaveLedger."Document No" := hrLeaveJournal."Document No.";
                leaveLedger."Leave Type" := hrLeaveJournal."Leave Type";
                leaveLedger."Transaction Date" := hrLeaveJournal."Posting Date";
                leaveLedger."Transaction Type" := hrLeaveJournal."Transaction Type";
                if ((hrLeaveJournal."Transaction Type" = hrLeaveJournal."transaction type"::"Positive Adjustment") or
                (hrLeaveJournal."Transaction Type" = hrLeaveJournal."transaction type"::Allocation)) then
                    leaveLedger."No. of Days" := hrLeaveJournal."No. of Days"
                else
                    if ((hrLeaveJournal."Transaction Type" = hrLeaveJournal."transaction type"::"Negative Adjustment") or
                    (hrLeaveJournal."Transaction Type" = hrLeaveJournal."transaction type"::Application)) then
                        leaveLedger."No. of Days" := ((hrLeaveJournal."No. of Days") * (-1));

                leaveLedger."Transaction Description" := hrLeaveJournal."Transaction Description";
                leaveLedger."Leave Period" := Date2dwy(Today, 3);

                leaveLedger.Insert;
                lastNo := lastNo + 10;
                // Insert into the ledger entry table

                // Remove prev balance if caryy forward not allowed
                if (hrLeaveJournal."Transaction Type" = hrLeaveJournal."transaction type"::Allocation) and (hrLeaveJournal."Allow Carry Forward" = true) then begin
                    leaveLedger.Init;
                    leaveLedger."Entry No." := lastNo;
                    leaveLedger."Employee No" := hrLeaveJournal."Staff No.";
                    leaveLedger."Document No" := hrLeaveJournal."Document No.";
                    leaveLedger."Leave Type" := hrLeaveJournal."Leave Type";
                    leaveLedger."Transaction Date" := hrLeaveJournal."Posting Date";
                    if hrLeaveJournal."Leave Balance" > 0 then
                        leaveLedger."Transaction Type" := hrLeaveJournal."transaction type"::"Positive Adjustment"
                    else
                        leaveLedger."Transaction Type" := hrLeaveJournal."transaction type"::"Negative Adjustment";

                    if leaveLedger."Transaction Type" = leaveLedger."transaction type"::"Positive Adjustment" then
                        leaveLedger."No. of Days" := hrLeaveJournal."Leave Balance";

                    if leaveLedger."Transaction Type" = leaveLedger."transaction type"::"Negative Adjustment" then
                        leaveLedger."No. of Days" := hrLeaveJournal."Leave Balance" * -1;

                    leaveLedger."Transaction Description" := 'Prev Year Leave Balance Adjustment';
                    leaveLedger."Leave Period" := Date2dwy(Today, 3);
                    if leaveLedger."No. of Days" <> 0 then
                        leaveLedger.Insert;
                    lastNo := lastNo + 10;
                end;

                if HrEmployee.Get(hrLeaveJournal."Staff No.") then begin
                end;
                Clear(Var1);
                counts := counts + 1;
                if counts = 1 then
                    RecCount1 := Format(counts) + '). ' + HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' +
                HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name"
                else
                    if counts = 2 then begin
                        RecCount2 := Format(counts) + '). ' + HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' +
                    HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name"
                    end
                    else
                        if counts = 3 then begin
                            RecCount3 := Format(counts) + '). ' + HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' +
                        HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name"
                        end
                        else
                            if counts = 4 then begin
                                RecCount4 := Format(counts) + '). ' + HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' +
                            HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name"
                            end
                            else
                                if counts = 5 then begin
                                    RecCount5 := Format(counts) + '). ' + HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' +
                                HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name"
                                end
                                else
                                    if counts = 6 then begin
                                        RecCount6 := Format(counts) + '). ' + HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' +
                                    HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name"
                                    end
                                    else
                                        if counts = 7 then begin
                                            RecCount7 := Format(counts) + '). ' + HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' +
                                        HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name"
                                        end
                                        else
                                            if counts = 8 then begin
                                                RecCount8 := Format(counts) + '). ' + HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' +
                                            HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name"
                                            end
                                            else
                                                if counts = 9 then begin
                                                    RecCount9 := Format(counts) + '). ' + HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' +
                                                HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name"
                                                end
                                                else
                                                    if counts = 10 then begin
                                                        RecCount10 := Format(counts) + '). ' + HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' +
                                                    HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name"
                                                    end else
                                                        if counts > 10 then begin
                                                            RecCount1 := RecCount2;
                                                            RecCount2 := RecCount3;
                                                            RecCount3 := RecCount4;
                                                            RecCount4 := RecCount5;
                                                            RecCount5 := RecCount6;
                                                            RecCount6 := RecCount7;
                                                            RecCount7 := RecCount8;
                                                            RecCount8 := RecCount9;
                                                            RecCount9 := RecCount10;
                                                            RecCount10 := Format(counts) + '). ' + HrEmployee."No." + ':' + HrEmployee."First Name" + ' ' +
                                                        HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name";
                                                        end;
                Clear(BufferString);
                BufferString := 'Total Records processed = ' + Format(counts);

                progre.Update();

            until hrLeaveJournal.Next = 0;
            ////Progress Window
            progre.Close;
        end;
        hrLeaveJournal.DeleteAll;
        Message('Leave Journal posted successfully!');
    end;

    procedure PostLeaveAllocation(EntryNo: Integer; EmployeeNo: Text[50]; LeaveType: Text; CalenderCode: Text)
    begin
        //Post Leave from leave allocation to leave ledger
        LeaveAllocation.Reset();
        LeaveAllocation.SetRange(LeaveAllocation."Entry No.", EntryNo);
        LeaveAllocation.SetRange(LeaveAllocation."No.", EmployeeNo);
        LeaveAllocation.SetRange(LeaveAllocation."Leave Type", LeaveType);
        LeaveAllocation.SetRange(LeaveAllocation."Calendar Code", CalenderCode);
        LeaveAllocation.SetRange(LeaveAllocation."Posted to Leave Ledger", false);
        IF LeaveAllocation.Find('-') then begin
            Clear(lastNo);
            leaveLedger.Reset;
            leaveLedger.SetFilter(leaveLedger."Entry No.", '<>%1', 0);
            if leaveLedger.FindLast then begin
                lastNo := leaveLedger."Entry No." + 10;
            end;

            leaveLedger.Init;
            leaveLedger."Entry No." := lastNo + 1;
            leaveLedger."Employee No" := EmployeeNo;
            leaveLedger."Document No" := LeaveAllocation."Document No.";
            leaveLedger."Leave Type" := LeaveAllocation."Leave Type";
            leaveLedger."Transaction Date" := LeaveAllocation."Posting Date";
            leaveLedger."Transaction Type" := LeaveAllocation."Entry Type";
            if (LeaveAllocation."Entry Type" = LeaveAllocation."Entry Type"::"Positive Adjustment")
            then
                leaveLedger."No. of Days" := LeaveAllocation."No. of Days"
            else
                if (LeaveAllocation."Entry Type" = LeaveAllocation."Entry Type"::"Negative Adjustment") then
                    leaveLedger."No. of Days" := ((LeaveAllocation."No. of Days") * (-1));

            leaveLedger."Transaction Description" := LeaveAllocation."Posting Description";
            leaveLedger."Leave Period" := Date2dwy(Today, 3);

            leaveLedger.Insert;
            LeaveAllocation."Posted to Leave Ledger" := true;
            LeaveAllocation.Modify();
        end;
    end;

    var
        lastNo: Integer;
        LeaveAllocation: Record "HR Leave Allocation";
        hrLeaveJournal: Record "HR Employee Leave Journal";
        leaveLedger: Record "HR Leave Ledger";
        HrEmployee: Record "HR-Employee";
}

