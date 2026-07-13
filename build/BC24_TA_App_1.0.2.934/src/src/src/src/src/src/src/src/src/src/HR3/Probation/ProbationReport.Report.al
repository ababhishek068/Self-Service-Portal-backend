namespace ABH_UAT.ABH_UAT;
using Microsoft.Foundation.Company;

report 50369 "Probation Report"
{
    ApplicationArea = All;
    Caption = 'Probation Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/probation.rdl';
    dataset
    {
        dataitem(ProbationLines; "Probation Lines")
        {
            RequestFilterFields = "probation code","Employee Code";
            column(EmployeeCode; "Employee Code")
            {
            }
            column(JobId; "Job Id")
            {
            }
            column(Rate; Rate)
            {
            }
            column(RateCode; "Rate Code")
            {
            }
            column(RateFactor; "Rate Factor")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(Value; "Value")
            {
            }
            column(probationcode; "probation code")
            {
            }
            column(CompEmail; CompInf."E-Mail")
            {
            }
            column(CompAddress; CompInf.Address) { }
            column(CompInf;CompInf.Picture){}
            trigger OnAfterGetRecord()
            var
                probation: Record "Probation Lines";
                
            begin
                probatioheader.Reset();
                probatioheader.SetRange(probatioheader."Employee No",ProbationLines."Employee Code");
                probatioheader.SetRange("Probation Code",ProbationLines."probation code");
                probatioheader.SetRange(probatioheader."Job ID",ProbationLines."Job Id");
                if probatioheader.Find('-') then begin
                    managerid:=probatioheader.Manager;
                    manager:=probatioheader."Manager's Name";
                    activity:=probatioheader."Activity Brief";
                    reccommend:=probatioheader."Employ Permanently?";
                    reason:=probatioheader.Reason;
                    hrcommends:=probatioheader."HR Comments";
                    DoJ:=probatioheader."Employment Date";
                    empname:=probatioheader."Employee Name";
                    depart:=probatioheader."Global Dimension 3 Code";
                    weakpoint:=probatioheader."Weak Points";                    

                  
                end;
               
            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get();
                CompInf.CalcFields(CompInf.Picture); 
            end;
        }
        }
        var
    CompInf: Record "Company Information";
        HREmp: Record "HR-Employee";
        EndDate: Date;
        ReturnDate: Date;
        StartDate: Date;
        LeaveBalance: Decimal;
        probatioheader: Record "Probation Header";
        empname: text[100];
        depart: code[50];
        DoJ:Date;
        activity: Text[250];
        weakpoint: text[250];
        reccommend: Boolean;
        reason: text[250];
        hrcommends: text[250];
        manager: text[250];
        managerid: Code[20];

    }
   
    

