page 50166 "Company Workplan Card"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Company Workplan Header";
    InsertAllowed = true;
    DeleteAllowed = false;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }

                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';
                }


                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }

            part("Company Workplan Lines"; "Company Workplan Lines")
            {
                Caption = 'Company Workplan Activities';
                ApplicationArea = All;
            }
        }

    }

    actions
    {
        area(processing)
        {

            group(Functions)
            {
                Caption = 'Functions';
                Visible = true;

                action("&Import")
                {
                    Caption = '&Import';
                    ApplicationArea = all;
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = xmlport "Import Workplan Activites";
                    ToolTip = 'Executes the &Import action.';

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                    end;
                }
                action("&Export")
                {
                    ApplicationArea = all;
                    Caption = '&Export';
                    Ellipsis = true;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = xmlport "Export Workplan Activites";
                    ToolTip = 'Executes the &Export action.';
                }
                action("Create G/L Budgets")
                {
                    ApplicationArea = all;
                    Image = CreateLedgerBudget;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Create G/L Budgets action.';
                    trigger OnAction();

                    var
                        BudgetaryControlSetup: Record "Budgetary Control Setup";
                        WorkplanActivities: Record "Workplan Activities";
                        GLBudgetEntry: Record "G/L Budget Entry";
                        ItemBudgetEntry: Record "Item Budget Entry";
                        Item: Record Item;
                        CreateGLBudgetEntries_Msg: Label '"Are you sure you want to create G/L Budget Entries from the approved consolidated corkplan activities? "';
                        Error_GLBudgetEntries_Err: Label 'Process aborted by user.';
                    begin

                        IF CONFIRM(CreateGLBudgetEntries_Msg, FALSE) = FALSE THEN ERROR(Error_GLBudgetEntries_Err);

                        BudgetaryControlSetup.RESET();
                        BudgetaryControlSetup.GET();

                        BudgetaryControlSetup.TESTFIELD(BudgetaryControlSetup."Current Item Budget");
                        BudgetaryControlSetup.TESTFIELD(BudgetaryControlSetup."Current Budget Code");
                        //BudgetaryControlSetup.TESTFIELD(BudgetaryControlSetup."Current Budget Start Date");
                        //BudgetaryControlSetup.TESTFIELD(BudgetaryControlSetup."Current Budget end Date");

                        //G/L Budgets
                        WorkplanActivities.RESET();
                        WorkplanActivities.SETRANGE(WorkplanActivities."Account Type", WorkplanActivities."Account Type"::Posting);
                        WorkplanActivities.SETRANGE(WorkplanActivities.Type, WorkplanActivities.Type::"G/L Account");
                        WorkplanActivities.SETRANGE(WorkplanActivities."Converted to G/L Budget", FALSE);
                        IF WorkplanActivities.FINDSET() THEN BEGIN
                            REPEAT
                                WorkplanActivities.TESTFIELD(WorkplanActivities."No.");
                                WorkplanActivities.TESTFIELD(WorkplanActivities."Global Dimension 1 Code");
                                WorkplanActivities.TESTFIELD(WorkplanActivities."Global Dimension 2 Code");
                                WorkplanActivities.TESTFIELD(WorkplanActivities.Description);

                                GLBudgetEntry.INIT();

                                GLBudgetEntry."Entry No." := fn_GetNextEntryNo_GLBudgetEntry();

                                GLBudgetEntry."Budget Name" := BudgetaryControlSetup."Current Budget Code";
                                GLBudgetEntry.VALIDATE("Budget Name");

                                GLBudgetEntry."G/L Account No." := WorkplanActivities."No.";
                                GLBudgetEntry.VALIDATE(GLBudgetEntry."G/L Account No.");

                                GLBudgetEntry."Global Dimension 1 Code" := WorkplanActivities."Global Dimension 1 Code";
                                GLBudgetEntry.VALIDATE(GLBudgetEntry."Global Dimension 1 Code");

                                GLBudgetEntry."Global Dimension 2 Code" := WorkplanActivities."Global Dimension 2 Code";
                                GLBudgetEntry.VALIDATE(GLBudgetEntry."Global Dimension 2 Code");

                                GLBudgetEntry.Description := WorkplanActivities.Description;

                                GLBudgetEntry.Date := WorkplanActivities."Date to Transfer";
                                GLBudgetEntry.WorkplanCode := WorkplanActivities."Procurement Workplan Code";

                                GLBudgetEntry.Amount := WorkplanActivities."Amount to Transfer";
                                GLBudgetEntry."User ID" := USERID;

                                GLBudgetEntry."Processed from Workplan" := TRUE;

                                GLBudgetEntry.INSERT(TRUE);

                                CounterVar += 1;

                                WorkplanActivities."Converted to G/L Budget" := TRUE;
                                WorkplanActivities."Converted to Budget by:" := USERID;

                                WorkplanActivities.MODIFY();

                            until WorkplanActivities.NEXT = 0;
                        end else begin
                            error('No entries found within the filter');
                        end;

                        //Item Budgets
                        WorkplanActivities.RESET();
                        WorkplanActivities.SETRANGE(WorkplanActivities."Account Type", WorkplanActivities."Account Type"::Posting);
                        WorkplanActivities.SETRANGE(WorkplanActivities.Type, WorkplanActivities.Type::Item);
                        WorkplanActivities.SETRANGE(WorkplanActivities."Converted to G/L Budget", FALSE);
                        IF WorkplanActivities.FINDSET() THEN BEGIN
                            REPEAT
                                ItemBudgetEntry.INIT();
                                ItemBudgetEntry."Entry No." := fn_GetNextEntryNo_ItemBudgetEntry();

                                ItemBudgetEntry."Analysis Area" := ItemBudgetEntry."Analysis Area"::Purchase;

                                ItemBudgetEntry."Budget Name" := BudgetaryControlSetup."Current Item Budget";
                                ItemBudgetEntry.VALIDATE(ItemBudgetEntry."Budget Name");

                                ItemBudgetEntry."Item No." := WorkplanActivities."No.";
                                ItemBudgetEntry.VALIDATE(ItemBudgetEntry."Item No.");

                                ItemBudgetEntry."Global Dimension 1 Code" := WorkplanActivities."Global Dimension 1 Code";
                                ItemBudgetEntry.VALIDATE(ItemBudgetEntry."Global Dimension 1 Code");

                                ItemBudgetEntry."Global Dimension 2 Code" := WorkplanActivities."Global Dimension 2 Code";
                                ItemBudgetEntry.VALIDATE(ItemBudgetEntry."Global Dimension 2 Code");

                                ItemBudgetEntry.Description := WorkplanActivities.Description;

                                ItemBudgetEntry.Date := WorkplanActivities."Date to Transfer";
                                ItemBudgetEntry.Quantity := WorkplanActivities.Quantity;

                                ItemBudgetEntry."Cost Amount" := WorkplanActivities."Amount to Transfer";

                                ItemBudgetEntry."User ID" := USERID;

                                ItemBudgetEntry.INSERT(TRUE);

                                WorkplanActivities."Converted to G/L Budget" := TRUE;
                                WorkplanActivities."Converted to Budget by:" := USERID;
                                WorkplanActivities.MODIFY();
                                //end Added Item

                                //Insert also into GL Budget Entries for respective "Item Budget G/L Account Code" on Item Card
                                Item.GET(WorkplanActivities."No.");
                                Item.TESTFIELD(Item."Item G/L Budget Account");

                                GLBudgetEntry.INIT;
                                GLBudgetEntry."Entry No." := fn_GetNextEntryNo_GLBudgetEntry();

                                GLBudgetEntry."Budget Name" := BudgetaryControlSetup."Current Budget Code";
                                GLBudgetEntry.VALIDATE("Budget Name");

                                GLBudgetEntry."G/L Account No." := Item."Item G/L Budget Account";
                                GLBudgetEntry.VALIDATE(GLBudgetEntry."G/L Account No.");

                                GLBudgetEntry."Global Dimension 1 Code" := WorkplanActivities."Global Dimension 1 Code";
                                GLBudgetEntry.VALIDATE(GLBudgetEntry."Global Dimension 1 Code");

                                GLBudgetEntry."Global Dimension 2 Code" := WorkplanActivities."Global Dimension 2 Code";
                                GLBudgetEntry.VALIDATE(GLBudgetEntry."Global Dimension 2 Code");

                                GLBudgetEntry.Description := WorkplanActivities.Description;

                                GLBudgetEntry.Date := WorkplanActivities."Date to Transfer";

                                GLBudgetEntry.WorkplanCode := WorkplanActivities."Procurement Workplan Code";
                                GLBudgetEntry.VALIDATE(GLBudgetEntry.WorkplanCode);

                                GLBudgetEntry.Amount := WorkplanActivities."Amount to Transfer";
                                GLBudgetEntry."User ID" := USERID;


                                GLBudgetEntry.INSERT(TRUE);

                                CounterVar += 1;

                                WorkplanActivities."Converted to G/L Budget" := TRUE;
                                WorkplanActivities."Converted to Budget by:" := USERID;

                                WorkplanActivities.MODIFY();
                            until WorkplanActivities.NEXT = 0;
                        end else begin
                            error('No entries found within the filter');
                        end;

                        Message('%1 G/L Budget Entries Created Successfully', CounterVar);
                    end;
                }
            }
        }
    }


    var
        CounterVar: Integer;

    local procedure fn_GetNextEntryNo_ItemBudgetEntry(): Integer;
    var
        ItemBudgetEntry_4: Record "Item Budget Entry";
    begin

        ItemBudgetEntry_4.SETCURRENTKEY("Entry No.");
        IF ItemBudgetEntry_4.FINDLAST THEN
            EXIT(ItemBudgetEntry_4."Entry No." + 1);

        EXIT(1);
    end;

    local procedure fn_GetNextEntryNo_GLBudgetEntry(): Integer;
    var
        GLBudgetEntry_4: Record "G/L Budget Entry";
    begin
        GLBudgetEntry_4.SETCURRENTKEY("Entry No.");
        IF GLBudgetEntry_4.FINDLAST THEN
            EXIT(GLBudgetEntry_4."Entry No." + 1);

        EXIT(1);
    end;
}