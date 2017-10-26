/*F******************************************************************************
 *
 * openSMILE - open Speech and Music Interpretation by Large-space Extraction
 *       the open-source Munich Audio Feature Extraction Toolkit
 * Copyright (C) 2008-2009  Florian Eyben, Martin Woellmer, Bjoern Schuller
 *
 *
 * Institute for Human-Machine Communication
 * Technische Universitaet Muenchen (TUM)
 * D-80333 Munich, Germany
 *
 *
 * If you use openSMILE or any code from openSMILE in your research work,
 * you are kindly asked to acknowledge the use of openSMILE in your publications.
 * See the file CITING.txt for details.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 ******************************************************************************E*/


/*  openSMILE component: cPlp

This component computes PLP and RASTA-PLP cepstral coefficients from a critical band spectrum (generated by the cMelspec component, for example).

The component is capable of performing the following processing steps:
   1) Take the natural logarithm of the critical band powers (doLog)
   2) RASTA filtering
   3) Computation of auditory spectrum (equal loudness curve and loudness compression)
   4) Inverse of the natural logarithm
   5) Inverse DFT to obtain autocorrelation coefficients
   6) Linear prediction analysis on autocorr. coeff.
   7) Computation of cepstral coefficients from lp coefficients
   8) Cepstral 'liftering'

*/



#ifndef __CPLP_HPP
#define __CPLP_HPP

#include <smileCommon.hpp>
#include <vectorProcessor.hpp>
#include <math.h>

#ifdef _N
#undef _N
#endif



#define COMPONENT_DESCRIPTION_CPLP "This component computes PLP and RASTA-PLP (currently the RASTA filter is not yet implemented) cepstral coefficients from a critical band spectrum (generated by the cMelspec component, for example).\n   The component is capable of performing the following processing steps: \n   1) Take the natural logarithm of the critical band powers (doLog)\n   2) RASTA filtering\n   3) Computation of auditory spectrum (equal loudness curve and loudness compression)\n   4) Inverse of the natural logarithm\n   5) Inverse DFT to obtain autocorrelation coefficients\n   6) Linear prediction analysis on autocorr. coeff.\n   7) Computation of cepstral coefficients from lp coefficients\n   8) Cepstral 'liftering'";

#define COMPONENT_NAME_CPLP "cPlp"

#undef class
class DLLEXPORT cPlp : public cVectorProcessor {
  private:
    int htkcompatible;
    int nAuto, nFreq, nScale;
    int lpOrder;
    int nCeps, firstCC, lastCC;

    int doLog, doAud, doInvLog, doIDFT, RASTA, doLP, doLpToCeps;

    FLOAT_DMEM cepLifter;
    
    FLOAT_DMEM **acf;
    FLOAT_DMEM **lpc;
    FLOAT_DMEM **ceps;

    FLOAT_DMEM compression;
    FLOAT_DMEM **eqlCurve; // equal loudness curve
    FLOAT_DMEM **costable; // IDFT
    FLOAT_DMEM **sintable; // cepstral liftering

    FLOAT_DMEM melfloor;
    
    int initTables( long blocksize, int idxc, int fidx );
    
  protected:
    SMILECOMPONENT_STATIC_DECL_PR

    virtual void fetchConfig();
    virtual int dataProcessorCustomFinalise();
    virtual int setupNamesForField(int i, const char*name, long nEl);

    //virtual int processVectorInt(const INT_DMEM *src, INT_DMEM *dst, long Nsrc, long Ndst, int idxi);
    virtual int processVectorFloat(const FLOAT_DMEM *src, FLOAT_DMEM *dst, long Nsrc, long Ndst, int idxi);

  public:
    SMILECOMPONENT_STATIC_DECL
    
    cPlp(const char *_name);

    virtual ~cPlp();
};




#endif // __CPLP_HPP
