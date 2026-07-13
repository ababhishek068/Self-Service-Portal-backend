page 51178 "Approved Proposal List"
{
    Caption = 'Grant List';
    CardPageID = "Approved Proposals Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = Jobs;
    SourceTableView = WHERE(Status = CONST(Proposal), "Approval Status" = FILTER(Approved));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Person Responsible"; Rec."Person Responsible")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Person Responsible field.';
                }
                field("Next Invoice Date"; Rec."Next Invoice Date")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Next Invoice Date field.';
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    Visible = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Kind of Program field.';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Search Description field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("W&IP")
            {
                Caption = 'W&IP';
                Visible = false;
                action("Calculate WIP")
                {
                    Caption = 'Calculate WIP';
                    Ellipsis = true;
                    Image = CalculateWIP;
                    ToolTip = 'Executes the Calculate WIP action.';

                    trigger OnAction()
                    var
                        Job: Record Jobs;
                    begin
                        Rec.TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"Job Calculate WIP", TRUE, FALSE, Job);
                    end;
                }
                action("Post WIP to G/L")
                {
                    Caption = 'Post WIP to G/L';
                    Ellipsis = true;
                    Image = Post;
                    ToolTip = 'Executes the Post WIP to G/L action.';

                    trigger OnAction()
                    var
                        Job: Record Jobs;
                    begin
                        Rec.TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L", TRUE, FALSE, Job);
                    end;
                }
                action("WIP Entries")
                {
                    Caption = 'WIP Entries';
                    RunObject = Page "Grant WIP Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Posting Group", "WIP Posting Date");
                    ToolTip = 'Executes the WIP Entries action.';
                }
                action("WIP G/L Entries")
                {
                    Caption = 'WIP G/L Entries';
                    RunObject = Page "Grant WIP G/L Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.");
                    ToolTip = 'Executes the WIP G/L Entries action.';
                }
            }
            group("&Prices")
            {
                Caption = '&Prices';
                Visible = false;
                action(Resource)
                {
                    Caption = 'Resource';
                    RunObject = Page "Grant Resource Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the Resource action.';
                }
                action(Item)
                {
                    Caption = 'Item';
                    RunObject = Page "Grant Item Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the Item action.';
                }
                action("G/L Account")
                {
                    Caption = 'G/L Account';
                    RunObject = Page "Grant G/L Account Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the G/L Account action.';
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                Visible = false;
                action("Resource &Allocated per Job")
                {
                    Caption = 'Resource &Allocated per Job';
                    RunObject = Page "Resource Allocated per Job";
                    ToolTip = 'Executes the Resource &Allocated per Job action.';
                }
                separator(Separator26) { }
                action("Res. Group All&ocated per Job")
                {
                    Caption = 'Res. Group All&ocated per Job';
                    RunObject = Page "Res. Gr. Allocated per Job";
                    ToolTip = 'Executes the Res. Group All&ocated per Job action.';
                }
            }
            group("&Grant")
            {
                Caption = '&Grant';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Approved Proposals Card";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Executes the Card action.';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Job), "No." = FIELD("No.");
                    ToolTip = 'Executes the Co&mments action.';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Grant Task Dimensions";
                        RunPageLink = "Job No." = FIELD("No."), "Job Task No." = CONST();
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'Executes the Dimensions-Single action.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        Caption = 'Dimensions-&Multiple';
                        ToolTip = 'Executes the Dimensions-&Multiple action.';

                        trigger OnAction()
                        var
                            Job: Record Jobs;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SETSELECTIONFILTER(Job);
                            //DefaultDimMultiple.SetMultiJob(Job);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Grant Ledger Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';
                }
                action("Grant Task Lines")
                {
                    Caption = 'Grant Task Lines';
                    ToolTip = 'Executes the Grant Task Lines action.';

                    trigger OnAction()
                    var
                        JTLines: Page "Grant Task Lines";
                    begin
                        JTLines.SetJobNo(Rec."No.");
                        JTLines.RUN;
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Grant Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        USetup.RESET;
        USetup.SETRANGE(USetup."User ID", USERID);
        USetup.SETRANGE(USetup."Grants Administrator", FALSE);
        IF USetup.FIND('-') THEN BEGIN
            mUserID := 'A';

            objResource.RESET;
            objResource.SETRANGE(objResource."User ID", USERID);
            IF objResource.FIND('-') THEN BEGIN
                mUserID := objResource."No.";
            END;

            Rec.SETRANGE("Principal Investigator", mUserID);
        END;
    end;

    trigger OnOpenPage()
    begin
        USetup.RESET;
        USetup.SETRANGE(USetup."User ID", USERID);
        USetup.SETRANGE(USetup."Grants Administrator", FALSE);
        IF USetup.FIND('-') THEN BEGIN
            mUserID := 'A';

            objResource.RESET;
            objResource.SETRANGE(objResource."User ID", USERID);
            IF objResource.FIND('-') THEN BEGIN
                mUserID := objResource."No.";
            END;

            Rec.SETRANGE("Principal Investigator", mUserID);
        END;
    end;

    var
        USetup: Record "User Setup";
        objResource: Record Resource;
        mUserID: Code[50];
}

