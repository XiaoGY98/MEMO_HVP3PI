#include "TROOT.h"
#include "TChain.h"
#include "TTree.h"
#include "TH1.h"
#include "iostream"
#include "TCanvas.h"
#include "TLegend.h"
#include "TGraphErrors.h"
#include "TMultiGraph.h"
#include "TLatex.h"
#include "TLorentzVector.h"
#include "TVector3.h"
#include "TVector.h"
#include "TFile.h"
#include "thisHead.h"
#include <iomanip>

using namespace std;

TVector3 m_beta(0.011, 0, 0);

bool isSelected_withKmfitChisqCut(int chisqcut, double lessMassCut)
{
    TLorentzVector PIP_P4(p4_pip[0], p4_pip[1], p4_pip[2], p4_pip[3]);
    TLorentzVector PIM_P4(p4_pim[0], p4_pim[1], p4_pim[2], p4_pim[3]);
    TLorentzVector PIZ_P4(p4_pi0[0], p4_pi0[1], p4_pi0[2], p4_pi0[3]);
    TLorentzVector ISRGam_P4(p4_gam_isr[0], p4_gam_isr[1], p4_gam_isr[2], p4_gam_isr[3]);
    TLorentzVector PIZ_GAM1_P4(p4_gam1_from_pi0[0], p4_gam1_from_pi0[1], p4_gam1_from_pi0[2], p4_gam1_from_pi0[3]);
    TLorentzVector PIZ_GAM2_P4(p4_gam2_from_pi0[0], p4_gam2_from_pi0[1], p4_gam2_from_pi0[2], p4_gam2_from_pi0[3]);
    TLorentzVector threePi = PIP_P4 + PIM_P4 + PIZ_P4;
    double ebeam = 1.8865;
    TLorentzVector p4cms(0.011 * 2 * ebeam, 0, 0, 2 * ebeam);
    // Umiss = Emiss - pmiss
    double Emiss = p4cms.E() - (PIP_P4 + PIM_P4 + PIZ_P4 + ISRGam_P4).E();
    double pmiss = (p4cms - (PIP_P4 + PIM_P4 + PIZ_P4 + ISRGam_P4)).P();
    double Umiss = Emiss - pmiss;
    // if (eopp > 0.8)
    //     return false;
    // if (eopm > 0.8)
    //     return false;
    if (chisqofpi0 > 10)
        return false;
    if (kmfit4Cchisq > chisqcut)
        return false;
    if (threePi.M() > 1.05 && ngoodpi0 != 1)
        return false;
    if (threePi.M() < 0.7 || threePi.M() > lessMassCut)
        return false;
    // if (Umiss < -0.15 || Umiss > 0.15)
    //     return false;

    return true;
}

void select()
{

    TChain *chain = new TChain("tree");

    chain->Add("/home/xiaogy/workArea/physics/HVP3PI/workspace/NOMINAL_WORK/makeroot/round16/phokhara_isr3pi.root");

    setBranch(chain);

    TH1F *hist_4CChisq = new TH1F("4CChisq", "4CChisq", 100, 0, 100);
    TH1F *hist_4CChisq_truth = new TH1F("4CChisq_truth", "4CChisq_truth", 100, 0, 100);

    TH1F *hist_1CChisq = new TH1F("1CChisq", "1CChisq", 100, 0, 100);
    TH1F *hist_1CChisq_truth = new TH1F("1CChisq_truth", "1CChisq_truth", 100, 0, 100);

    TH1F *hist_isrTheta = new TH1F("isrTheta", "isrTheta", 36, 0, 180);
    TH1F *hist_isrTheta_truth = new TH1F("isrTheta_truth", "isrTheta_truth", 36, 0, 180);

    TH1F *hist_isrcosTheta = new TH1F("isrcosTheta", "isrcosTheta", 50, -1, 1);
    TH1F *hist_isrcosTheta_truth = new TH1F("isrcosTheta_truth", "isrcosTheta_truth", 50, -1, 1);

    TH1F *hist_isrPhi = new TH1F("isrPhi", "isrPhi", 60, -180, 180);
    TH1F *hist_isrPhi_truth = new TH1F("isrPhi_truth", "isrPhi_truth", 60, -180, 180);

    TH1F *hist_isrE = new TH1F("isrE", "isrE", 50, 0, 2);
    TH1F *hist_isrE_truth = new TH1F("isrE_truth", "isrE_truth", 50, 0, 2);

    TH1F *hist_E3PI = new TH1F("E3PI", "E3PI", 150, 1, 4);
    TH1F *hist_E3PI_truth = new TH1F("E3PI_truth", "E3PI_truth", 150, 1, 4);

    TH1F *hist_M3PI = new TH1F("M3PI", "M3PI", 130, 0.7, 2.0);
    TH1F *hist_M3PI_truth = new TH1F("M3PI_truth", "M3PI_truth", 130, 0.7, 2.0);

    TH1F *hist_EOPP = new TH1F("EOPP", "EOPP", 100, 0, 1.0);
    TH1F *hist_EOPP_truth = new TH1F("EOPP_truth", "EOPP_truth", 100, 0, 1.0);

    TH1F *hist_EOPM = new TH1F("EOPM", "EOPM", 100, 0, 1.0);
    TH1F *hist_EOPM_truth = new TH1F("EOPM_truth", "EOPM_truth", 100, 0, 1.0);

    TH1F *hist_M3PI_Region1 = new TH1F("M3PI_Region1", "M3PI_Region1", 40, 0.7, 0.9);
    TH1F *hist_M3PI_Region1_truth = new TH1F("M3PI_Region1_truth", "M3PI_Region1_truth", 40, 0.7, 0.9);

    TH1F *hist_M3PI_Region2 = new TH1F("M3PI_Region2", "M3PI_Region2", 30, 0.9, 1.05);
    TH1F *hist_M3PI_Region2_truth = new TH1F("M3PI_Region2_truth", "M3PI_Region2_truth", 30, 0.9, 1.05);  

    TH1F *hist_M3PI_Region3 = new TH1F("M3PI_Region3", "M3PI_Region3", 76, 1.05, 2.0);
    TH1F *hist_M3PI_Region3_truth = new TH1F("M3PI_Region3_truth", "M3PI_Region3_truth", 76, 1.05, 2.0);

    TH1F *hist_UnConMassPI0 = new TH1F("UnConMassPI0", "UnConMassPI0", 80, 0.1, 0.18);
    TH1F *hist_UnConMassPI0_truth = new TH1F("UnConMassPI0_truth", "UnConMassPI0_truth", 80, 0.1, 0.18);

    TH1F *hist_NGOODPI0 = new TH1F("NGOODPI0", "NGOODPI0", 10, 0., 10);
    TH1F *hist_NGOODPI0_truth = new TH1F("NGOODPI0_truth", "NGOODPI0_truth", 10, 0., 10);


    const int Nentries = chain->GetEntries();
    double Flag = 1;
    for (int i = 0; i < (int)(Nentries); i++)
    {
        chain->GetEntry(i);

        double per = (double)i / (double)(Nentries);
        if (per >= 0.01 * Flag) // 每1%更新一次，避免频繁刷新控制台
        {
            Flag++;

            int barWidth = 50;        // 控制台中进度条的宽度
            int pos = barWidth * per; // 当前进度对应的位置
            std::cout << "[";
            for (int j = 0; j < barWidth; ++j) // 绘制进度条
            {
                if (j < pos)
                    std::cout << "=";
                else if (j == pos)
                    std::cout << ">";
                else
                    std::cout << " ";
            }
            std::cout << "]  " << std::fixed << std::setprecision(2) << per * 100.0 << " % " << "\r"; // 使用'\r'回到行首
            std::cout.flush();                                                                        // 确保输出被刷新到控制台
        }

        int isrIndex = 999;
        double maxE = 0;
        for (int j = 0; j < Numtruth; j++)
        {
            if (IDtruth[j] == 22)
            {
                TLorentzVector ISRP4_Truth_WithOutREC(P4truth[j][0], P4truth[j][1], P4truth[j][2], P4truth[j][3]);
                if (ISRP4_Truth_WithOutREC.E() > maxE)
                {
                    maxE = ISRP4_Truth_WithOutREC.E();
                    isrIndex = j;
                }
            }
        }

        int pi0Index = 999;
        for (int j = 0; j < Numtruth; j++)
        {
            if (pi0Index != 999 && IDtruth[j] == 111)
            {
                cout << "More than one pi0!!!" << endl;
                break;
            }
            if (IDtruth[j] == 111)
                pi0Index = j;
        }

        double chisqcut = 100;
        double masscut = 2.0;

        if (!isSelected_withKmfitChisqCut(chisqcut, masscut))
            continue;

        TLorentzVector ISRP4_Truth_WithOutREC(P4truth[isrIndex][0], P4truth[isrIndex][1], P4truth[isrIndex][2], P4truth[isrIndex][3]);
        TLorentzVector Pi0P4_Truth_WithOutREC(P4truth[pi0Index][0], P4truth[pi0Index][1], P4truth[pi0Index][2], P4truth[pi0Index][3]);
        TLorentzVector PIP_P4(p4_pip[0], p4_pip[1], p4_pip[2], p4_pip[3]);
        TLorentzVector PIM_P4(p4_pim[0], p4_pim[1], p4_pim[2], p4_pim[3]);
        TLorentzVector PIZ_P4(p4_pi0[0], p4_pi0[1], p4_pi0[2], p4_pi0[3]);
        TLorentzVector ISRGam_P4(p4_gam_isr[0], p4_gam_isr[1], p4_gam_isr[2], p4_gam_isr[3]);
        TLorentzVector PIZ_GAM1_P4(p4_gam1_from_pi0[0], p4_gam1_from_pi0[1], p4_gam1_from_pi0[2], p4_gam1_from_pi0[3]);
        TLorentzVector PIZ_GAM2_P4(p4_gam2_from_pi0[0], p4_gam2_from_pi0[1], p4_gam2_from_pi0[2], p4_gam2_from_pi0[3]);
        TLorentzVector threePi = PIP_P4 + PIM_P4 + PIZ_P4;

        hist_NGOODPI0->Fill(ngoodpi0);
        hist_UnConMassPI0->Fill(pi0_unconmass);
        hist_M3PI->Fill(threePi.M());
        hist_E3PI->Fill(threePi.E());
        hist_M3PI_Region1->Fill(threePi.M());
        hist_M3PI_Region2->Fill(threePi.M());
        hist_M3PI_Region3->Fill(threePi.M());
        hist_isrTheta->Fill(ISRGam_P4.Theta() * 180 / 3.1415926);
        hist_isrcosTheta->Fill(ISRGam_P4.CosTheta());
        hist_isrPhi->Fill(ISRGam_P4.Phi() * 180 / 3.1415926);
        hist_isrE->Fill(ISRGam_P4.E());
        hist_4CChisq->Fill(kmfit4Cchisq);
        hist_EOPP->Fill(eopp);
        hist_EOPM->Fill(eopm);

        if (MatchISRAngle(ISRGam_P4, ISRP4_Truth_WithOutREC) && MatchPi0Angle(PIZ_P4, Pi0P4_Truth_WithOutREC))
        {
            hist_NGOODPI0_truth->Fill(ngoodpi0);
            hist_UnConMassPI0_truth->Fill(pi0_unconmass);
            hist_M3PI_truth->Fill(threePi.M());
            hist_E3PI_truth->Fill(threePi.E());
            hist_M3PI_Region1_truth->Fill(threePi.M());
            hist_M3PI_Region2_truth->Fill(threePi.M());
            hist_M3PI_Region3_truth->Fill(threePi.M());
            hist_isrTheta_truth->Fill(ISRGam_P4.Theta() * 180 / 3.1415926);
            hist_isrcosTheta_truth->Fill(ISRGam_P4.CosTheta());
            hist_isrPhi_truth->Fill(ISRGam_P4.Phi() * 180 / 3.1415926);
            hist_isrE_truth->Fill(ISRGam_P4.E());
            hist_4CChisq_truth->Fill(kmfit4Cchisq);
            hist_EOPP_truth->Fill(eopp);
            hist_EOPM_truth->Fill(eopm);
        }
    }

    DrawHistWithTruth(hist_isrcosTheta, hist_isrcosTheta_truth, "isrcosTheta", "", 2);
    DrawHistWithTruth(hist_isrTheta, hist_isrTheta_truth, "isrTheta", "deg", 2);
    DrawHistWithTruth(hist_isrPhi, hist_isrPhi_truth, "isrPhi", "deg", 2);
    DrawHistWithTruth(hist_isrE, hist_isrE_truth, "isrE", "GeV", 2);
    DrawHistWithTruth(hist_M3PI, hist_M3PI_truth, "M3PI", "GeV", 2);
    DrawHistWithTruth(hist_E3PI, hist_E3PI_truth, "E3PI", "GeV", 2);
    DrawHistWithTruth(hist_M3PI, hist_M3PI_truth, "M3PI_LOGY", "GeV", 2, 1);
    DrawHistWithTruth(hist_M3PI_Region1, hist_M3PI_Region1_truth, "m_{3#pi}^{#omega}", "GeV/c^{2}", 2);
    DrawHistWithTruth(hist_M3PI_Region2, hist_M3PI_Region2_truth, "m_{3#pi}^{#phi}", "GeV/c^{2}", 2);
    DrawHistWithTruth(hist_M3PI_Region3, hist_M3PI_Region3_truth, "m_{3#pi}^{high}", "GeV/c^{2}", 2);
    DrawHistWithTruth(hist_UnConMassPI0, hist_UnConMassPI0_truth, "UnConMassPI0", "GeV/c^{2}", 2);
    DrawHistWithTruth(hist_4CChisq, hist_4CChisq_truth, "Kmfit Chisq", "", 2);
    DrawHistWithTruth(hist_NGOODPI0, hist_NGOODPI0_truth, "NGOODPI0", "", 2);
    DrawHistWithTruth(hist_EOPP, hist_EOPP_truth, "EOPP", "", 2);
    DrawHistWithTruth(hist_EOPM, hist_EOPM_truth, "EOPM", "", 2);

    // 创建一个 ROOT 文件
    TFile *file = new TFile("output.root", "RECREATE"); // 你可以修改文件名为你需要的名字

    // 保存直方图到文件中
    hist_isrcosTheta->Write();

    // 关闭 ROOT 文件
    file->Close();
}
