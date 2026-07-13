page 50456 "Project List"
{
    Caption = 'Project Summary List';
    CardPageID = "Project Card";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Jobs;
    SourceTableView = WHERE(Status = CONST(Project), "Approval Status" = FILTER(<> Approved));
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
                field("Indirect Cost"; Rec."Indirect Cost")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Indirect Cost field.';
                }
                field("Allowed Indirect Cost"; Rec."Allowed Indirect Cost")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Allowed Indirect Cost field.';
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
        area(factboxes)
        {
            systempart(Control9; Links)
            {
                Editable = false;
                Visible = true;
            }
            systempart(Control8; Notes)
            {
                Visible = true;
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
                    ApplicationArea = basic;
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
                    ApplicationArea = basic;
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
                    ApplicationArea = basic;
                    RunObject = Page "Grant WIP Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Posting Group", "WIP Posting Date");
                    ToolTip = 'Executes the WIP Entries action.';
                }
                action("WIP G/L Entries")
                {
                    Caption = 'WIP G/L Entries';
                    ApplicationArea = basic;
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
                    ApplicationArea = basic;
                    RunObject = Page "Grant Resource Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the Resource action.';
                }
                action(Item)
                {
                    Caption = 'Item';
                    RunObject = Page "Grant Item Prices";
                    ApplicationArea = basic;
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'Executes the Item action.';
                }
                action("G/L Account")
                {
                    Caption = 'G/L Account';
                    ApplicationArea = basic;
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
                    ApplicationArea = basic;
                    RunObject = Page "Resource Allocated per Job";
                    ToolTip = 'Executes the Resource &Allocated per Job action.';
                }
                separator(Separator26) { }
                action("Res. Group All&ocated per Job")
                {
                    ApplicationArea = basic;
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
                    ApplicationArea = basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Proposal Card";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Executes the Card action.';
                }
                action(Budget)
                {
                    ApplicationArea = basic;
                    Caption = 'Budget';
                    Image = EditLines;
                    RunObject = Page Budget;
                    ToolTip = 'Executes the Budget action.';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    ApplicationArea = basic;
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
                        ApplicationArea = basic;
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Grant Task Dimensions";
                        RunPageLink = "Job No." = FIELD("No."), "Job Task No." = CONST();
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'Executes the Dimensions-Single action.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        Caption = 'Dimensions-&Multiple';
                        ApplicationArea = basic;
                        ToolTip = 'Executes the Dimensions-&Multiple action.';
                        trigger OnAction()
                        var
                            Job: Record Jobs;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SETSELECTIONFILTER(Job);
                            // DefaultDimMultiple.SetMultiJob(Job);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    ApplicationArea = basic;
                    RunObject = Page "Grant Ledger Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';
                }
                action("Grant Task Lines")
                {
                    Caption = 'Grant Task Lines';
                    ApplicationArea = basic;
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
                    ApplicationArea = basic;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Grant Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';
                }
            }
        }
        area(reporting)
        {

            action("39003902")
            {
                ApplicationArea = basic;
                Caption = 'Grant  list';
                Image = "report";
                RunObject = Report "Grant  list";
                ToolTip = 'Executes the Grant  list action.';
            }
            action("39006039")
            {
                ApplicationArea = basic;
                Caption = 'Project Donors';
                Image = "report";
                RunObject = Report "Project Donors";
                ToolTip = 'Executes the Project Donors action.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        objResource.RESET;
        objResource.SETRANGE(objResource."User ID", USERID);
        IF objResource.FIND('-') THEN BEGIN
            Rec.SETFILTER("Principal Investigator", objResource."No.");
        END;
    end;

    trigger OnOpenPage()
    begin
        objResource.RESET;
        objResource.SETRANGE(objResource."User ID", USERID);
        IF objResource.FIND('-') THEN BEGIN
            Rec.SETFILTER("Principal Investigator", objResource."No.");
        END;
    end;

    var
        objResource: Record Resource;
}

