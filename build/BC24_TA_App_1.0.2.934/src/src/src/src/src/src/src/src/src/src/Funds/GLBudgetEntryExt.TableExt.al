TableExtension 50020 "G/L Budget Entry Ext" extends "G/L Budget Entry"
{
    fields
    {


        field(39006073; "Budget Dimension 5 Code"; Code[10])
        {

            trigger OnValidate()
            begin
                /*IF "Budget Dimension 5 Code" <> xRec."Budget Dimension 5 Code" THEN BEGIN
                  IF Dim.CheckIfDimUsed("Budget Dimension 5 Code",12,Name,'',0) THEN
                    ERROR(Text000,Dim.GetCheckDimErr);
                  MODIFY;
                  UpdateBudgetDim("Budget Dimension 5 Code",4);
                END;
                */

            end;
        }
        field(39006074; "Budget Dimension 6 Code"; Code[20])
        {
            Caption = 'Budget Dimension 4 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                /*
                IF "Budget Dimension 6 Code" <> xRec."Budget Dimension 6 Code" THEN BEGIN
                  IF Dim.CheckIfDimUsed("Budget Dimension 6 Code",12,Name,'',0) THEN
                    ERROR(Text000,Dim.GetCheckDimErr);
                  MODIFY;
                  UpdateBudgetDim("Budget Dimension 6 Code",5);
                END;
                */

            end;
        }
        field(39006075; "Transferred from Item Budget"; Boolean) { }
        field(39006076; WorkplanCode; Code[20])
        {
            TableRelation = Workplan."Workplan Code.";
        }
        field(39006077; "Processed from Workplan"; Boolean) { }
        field(39006078; "Entry Type"; Option)
        {
            OptionCaption = ' ,Original,Adjustment';
            OptionMembers = " ",Original,Adjustment;
        }
        field(51000; "Description 3"; text[200]) { }
        field(51001; Donor; code[20]) { }
        field(51002; "Project No"; code[20]) { }
        field(51003; "Contract Entry No"; Integer) { }


    }




}

