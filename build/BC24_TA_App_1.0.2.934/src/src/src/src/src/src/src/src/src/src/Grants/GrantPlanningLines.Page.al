Page 50077 "Grant Planning Lines"
{
    Caption = 'Grant Budget Lines';
    DataCaptionExpression = Rec.Caption2;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Job-Task";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(GrantTaskNo; Rec."Grant Task No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Grant Task No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Grant Task No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
            part(PlanningLines; "Grant Planning Line Subform")
            {
                ApplicationArea = basic;
                SubPageLink = "Grant No." = field("Grant No."),
                              "Grant Task No." = field("Grant Task No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                action(TransferLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Lines';
                    ToolTip = 'Executes the Transfer Lines action.';

                    trigger OnAction()
                    begin

                        if Confirm('Are you sure you want to Transfer Lines to Budget?', false) = true then begin

                            Job.Reset();
                            Job.Get(Rec."Grant No.");
                            //StartDate:=Job."Starting Date";

                            if Job."Approval Status" <> Job."approval status"::Approved then Error('The grant has to be approved to set budget');
                            mGLAccount := '';
                            BudgetSetup.Find('-');
                            PlanningLines.Reset();
                            PlanningLines.SetRange(PlanningLines."Grant Task No.", Rec."Grant Task No.");
                            PlanningLines.SetRange(PlanningLines."Budget in use", true);
                            if PlanningLines.Find('-') then
                                repeat
                                    mGLAccount := '';
                                    //____________________________________
                                    if PlanningLines.Type = PlanningLines.Type::Item then begin
                                        objItem.Reset;
                                        objItem.SetRange(objItem."No.", PlanningLines."No.");
                                        if objItem.Find('-') then begin
                                            mGLAccount := objItem."Item G/L Budget Account";
                                        end;
                                    end
                                    else
                                        if PlanningLines.Type = PlanningLines.Type::Resource then begin
                                            objResource.Reset;
                                            objResource.SetRange(objResource."No.", PlanningLines."No.");
                                            if objResource.Find('-') then begin
                                                mGLAccount := '';//objResource."Item G/L Budget Account";
                                            end
                                        end
                                        else
                                            if PlanningLines.Type = PlanningLines.Type::"G/L Account" then begin
                                                mGLAccount := PlanningLines."No.";
                                            end;

                                    //_____________________________________

                                    if PlanningLines."Transfered To Budget" = false then begin
                                        BudgetEntry.Reset;
                                        if BudgetEntry.Find('+') then begin
                                            LastEntryNo := BudgetEntry."Entry No.";
                                        end;
                                        BudgetEntry.Init;
                                        BudgetEntry."Entry No." := LastEntryNo + 1;
                                        BudgetEntry."Budget Name" := BudgetSetup."Current Budget Code";
                                        BudgetEntry.Date := PlanningLines."Planning Date";//StartDate;
                                        BudgetEntry."G/L Account No." := PlanningLines."No.";
                                        BudgetEntry.Description := PlanningLines.Description;
                                        BudgetEntry."Description 3" := PlanningLines."Description 3";

                                        BudgetEntry.Amount := PlanningLines."Total Cost (LCY)";
                                        BudgetEntry.Donor := Job."Bill-to Partner No.";
                                        BudgetEntry."Project No" := Job."No.";
                                        BudgetEntry."Global Dimension 1 Code" := Job."Global Dimension 1 Code";
                                        BudgetEntry.Validate("Global Dimension 1 Code");
                                        BudgetEntry."Global Dimension 2 Code" := Job."Global Dimension 2 Code";
                                        BudgetEntry.Validate("Global Dimension 2 Code");
                                        // PlanningLines.TestField("Shortcut Dimension 3 Code");
                                        //PlanningLines.TESTFIELD("Shortcut Dimension 4 Code");
                                        BudgetEntry."Budget Dimension 3 Code" := PlanningLines."Shortcut Dimension 3 Code";
                                        BudgetEntry."Budget Dimension 4 Code" := PlanningLines."Shortcut Dimension 4 Code";
                                        // BudgetEntry."Contract Entry No" := PlanningLines."Grant Contract Entry No.";
                                        BudgetEntry.Insert;
                                        PlanningLines."Transfered To Budget" := true;
                                        PlanningLines.Modify;

                                        Commit;
                                    end else begin
                                        BudgetEntry.Reset;
                                        // BudgetEntry.SETRANGE(BudgetEntry."Contract Entry No",PlanningLines."Grant Contract Entry No.");
                                        BudgetEntry.SetRange(BudgetEntry.Date, PlanningLines."Planning Date");//StartDate;
                                        BudgetEntry.SetRange(BudgetEntry."Budget Name", BudgetSetup."Current Budget Code");
                                        BudgetEntry.SetRange(BudgetEntry."G/L Account No.", mGLAccount);
                                        BudgetEntry.SetRange(BudgetEntry."Project No", Job."No.");
                                        BudgetEntry.SetRange(BudgetEntry."Global Dimension 1 Code", Job."Global Dimension 1 Code");
                                        BudgetEntry.SetRange(BudgetEntry."Global Dimension 2 Code", Job."Global Dimension 2 Code");
                                        BudgetEntry.SetRange(BudgetEntry."Budget Dimension 3 Code", ''); //Temporary to remove after this exrcise
                                        if BudgetEntry.Find('-') then begin
                                            BudgetEntry.Date := PlanningLines."Planning Date";//StartDate;
                                            BudgetEntry."Budget Name" := BudgetSetup."Current Budget Code";
                                            BudgetEntry."G/L Account No." := mGLAccount;
                                            BudgetEntry.Description := PlanningLines.Description;
                                            BudgetEntry.Donor := Job."Bill-to Partner No.";
                                            BudgetEntry."Project No" := Job."No.";
                                            BudgetEntry."Global Dimension 1 Code" := Job."Global Dimension 1 Code";
                                            BudgetEntry."Global Dimension 2 Code" := Job."Global Dimension 2 Code";
                                            //  PlanningLines.TestField("Shortcut Dimension 3 Code");
                                            // //PlanningLines.TESTFIELD("Shortcut Dimension 4 Code");
                                            BudgetEntry."Budget Dimension 3 Code" := PlanningLines."Shortcut Dimension 3 Code";
                                            BudgetEntry."Budget Dimension 4 Code" := PlanningLines."Shortcut Dimension 4 Code";
                                            BudgetEntry.Amount := PlanningLines."Total Cost (LCY)";
                                            BudgetEntry.Modify;
                                        end
                                    end
                                until PlanningLines.Next = 0;
                            Message('Transfer Complete.');
                        end
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Job.Get(Rec."Grant No.") then
            CurrPage.Editable(not (Job.Blocked = Job.Blocked::All));
    end;

    var
        Job: Record Jobs;
        //AppMgt: Codeunit UnknownCodeunit439;
        PlanningLines: Record "Job-Planning Line";
        BudgetSetup: Record "Budgetary Control Setup";
        BudgetEntry: Record "G/L Budget Entry";
        LastEntryNo: Integer;
        objItem: Record Item;
        mGLAccount: Code[20];
        objResource: Record Resource;
}

