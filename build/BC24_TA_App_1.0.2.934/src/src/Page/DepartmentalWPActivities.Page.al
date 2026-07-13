page 50213 "Departmental WP Activities"
{
    Caption = 'Workplan Activities';
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = true;
    PageType = ListPart;
    SourceTable = "Workplan Activities";
    PromotedActionCategories = 'New,Process,Reports,Functions';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Procurement Workplan Code"; Rec."Procurement Workplan Code")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Procurement Workplan Code field.';
                }

                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ToolTip = 'Specifies the value of the Activity Code field.';
                }

                field("Activity Description"; Rec."Activity Description")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ToolTip = 'Specifies the value of the Activity Description field.';
                }
                field("Activity Type"; Rec."Activity Type")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                    ToolTip = 'Specifies the value of the Activity Type field.';
                }

                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }

                field("Activity Start Date"; Rec."Activity Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Activity Start Date field.';
                    //Editable = FieldEditable;
                }

                field("Activity End Date"; Rec."Activity End  Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Activity End  Date field.';
                    //Editable = FieldEditable;
                }
                field("Category Sub Plan"; Rec."Category Sub Plan")
                {
                    ApplicationArea = All;
                    Caption = 'Supplier Category';
                    ToolTip = 'Specifies the value of the Supplier Category field.';
                    //Editable = FieldEditable;
                }

                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                    //Editable = FieldEditable;
                }

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                    //Editable = FieldEditable;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                    //Editable = FieldEditable;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                    //Editable = FieldEditable;
                }
                field("Source of Activity Fund"; Rec."Source of Activity Fund")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source of Activity Fund field.';
                    //Editable = FieldEditable;
                }


                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    //Editable = FieldEditable;
                }

                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    //Editable = FieldEditable;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                    //Editable = FieldEditable;
                }

                field("Procurement Method"; Rec."Procurement Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Procurement Method field.';
                    //Editable = FieldEditable;
                }
                field("Planned Procurement Quarter"; Rec."Planned Procurement Quarter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Planned Procurement Quarter field.';
                    //Editable = FieldEditable;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    //Editable = FieldEditable; 
                }

                field("Unit of Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                    //Editable = FieldEditable;
                }

                field("Amount to Transfer"; Rec."Amount to Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount to Transfer field.';
                    //Editable = FieldEditable;
                }

                field("Date to Transfer"; Rec."Date to Transfer")
                {
                    ApplicationArea = All;
                    Caption = 'Activity Date';
                    ToolTip = 'Specifies the value of the Activity Date field.';
                    //Editable = FieldEditable;
                }

                field("Converted to G/L Budget"; Rec."Converted to G/L Budget")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Converted to G/L Budget field.';
                }

                field("Comments"; Rec."Comments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comments field.';
                    //Editable = FieldEditable;
                }


                field(Totalling; Rec.Totalling)
                {
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                    ToolTip = 'Specifies the value of the Totalling field.';
                }

                field("Approved Quantity"; Rec."Approved Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Approved Quantity field.';
                }
                field("Approved Unit Cost"; Rec."Approved Unit Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Approved Unit Cost field.';
                    trigger OnValidate()
                    var
                    begin
                        Rec."Approved Total Cost" := Rec."Approved Unit Cost" * Rec."Approved Quantity";
                    end;

                }
                field("Approved Total Cost"; Rec."Approved Total Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Approved Total Cost field.';
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
                Caption = 'Functions';
                Visible = true;

                action("&Print")
                {
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the &Print action.';

                    trigger OnAction();
                    begin
                        Message('Function to print report here');
                    end;
                }

                action(IndentWorkplan)
                {
                    Caption = '&Indent Workplan Activities';
                    Image = IndentChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the &Indent Workplan Activities action.';

                    trigger OnAction();
                    var
                        Text000: Label 'This function updates the indentation of all the Workplan Items in the Workplan card. ';
                        Text001: Label 'All accounts between a Begin-Total and the matching End-Total are indented one level. ';
                        Text002: Label 'The Totaling for each End-total is also updated.';
                        Text003: Label '\\Do you want to indent the Workplan List?';
                        Text005: Label 'End-Total %1 is missing a matching Begin-Total.';
                        GLAcc: Record "Workplan Activities";
                        Window: Dialog;
                        AccNo: array[10] of Code[20];
                        i: Integer;

                    begin
                        IF NOT
                        CONFIRM(
                            Text000 +
                            Text001 +
                            Text002 +
                            Text003, TRUE)
                        THEN
                            EXIT;

                        IF GLAcc.FIND('-') THEN
                            REPEAT
                                Window.UPDATE(1, GLAcc."Activity Code");

                                IF GLAcc."Account Type" = GLAcc."Account Type"::"End-Total" THEN BEGIN
                                    IF i < 1 THEN
                                        ERROR(
                                          Text005,
                                          GLAcc."Activity Code");
                                    GLAcc.Totalling := AccNo[i] + '..' + GLAcc."Activity Code";
                                    i := i - 1;
                                END;

                                GLAcc.Indentation := i;
                                GLAcc.MODIFY;

                                IF GLAcc."Account Type" = GLAcc."Account Type"::"Begin-Total" THEN BEGIN
                                    i := i + 1;
                                    AccNo[i] := GLAcc."Activity Code";
                                END;
                            UNTIL GLAcc.NEXT = 0;

                        Window.CLOSE;

                    end;
                }
            }

        }
    }

    trigger OnAfterGetRecord();
    begin
        NoEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

    var
        [InDataSet]
        NoEmphasize: Boolean;
        [InDataSet]
        NameEmphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;


    procedure CheckRequiredFields();
    begin

        Rec.TESTFIELD("Account Type");
        Rec.TESTFIELD("Activity Description");
        Rec.TESTFIELD("Procurement Workplan Code");
        Rec.TESTFIELD("Date to Transfer", 0D);
    end;

    procedure LockFieldsOnBeginEndTotal(AccType: Integer): Boolean
    var
    begin
        //1 = Posting,2= Begin-Total,3 = End-Total
        //if AccType in [2, 3] then exit(false) else exit(true);
    end;

}

