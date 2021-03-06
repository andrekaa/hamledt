#!/usr/bin/perl
# Collects tags from a corpus in CSTS format.
# (c) 2006 Dan Zeman <zeman@ufal.mff.cuni.cz>
# Licence: GNU GPL

use utf8;
use open ":utf8";
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my %conv =
(
    "A"                                     => "AAXXX----1A----",
    "A ЕД ЖЕН ВИН"                          => "AAFS4----1A----",
    "A ЕД ЖЕН ДАТ"                          => "AAFS3----1A----",
    "A ЕД ЖЕН ИМ"                           => "AAFS1----1A----",
    "A ЕД ЖЕН ИМ МЕТА"                      => "AAFS1----1A----",
    "A ЕД ЖЕН ПР"                           => "AAFS6----1A----",
    "A ЕД ЖЕН РОД"                          => "AAFS2----1A----",
    "A ЕД ЖЕН ТВОР"                         => "AAFS7----1A----",
    "A ЕД МУЖ ВИН НЕОД"                     => "AAIS4----1A----",
    "A ЕД МУЖ ВИН ОД"                       => "AAMS4----1A----",
    "A ЕД МУЖ ДАТ"                          => "AAMS3----1A----",
    "A ЕД МУЖ ИМ"                           => "AAMS1----1A----",
    "A ЕД МУЖ ПР"                           => "AAMS6----1A----",
    "A ЕД МУЖ РОД"                          => "AAMS2----1A----",
    "A ЕД МУЖ ТВОР"                         => "AAMS7----1A----",
    "A ЕД СРЕД ВИН"                         => "AANS4----1A----",
    "A ЕД СРЕД ДАТ"                         => "AANS3----1A----",
    "A ЕД СРЕД ИМ"                          => "AANS1----1A----",
    "A ЕД СРЕД ПР"                          => "AANS6----1A----",
    "A ЕД СРЕД РОД"                         => "AANS2----1A----",
    "A ЕД СРЕД ТВОР"                        => "AANS7----1A----",
    "A КР ЕД ЖЕН"                           => "ACFS-----1A----",
    "A КР ЕД МУЖ"                           => "ACMS-----1A----",
    "A КР ЕД СРЕД"                          => "ACNS-----1A----",
    "A КР МН"                               => "ACXP-----1A----",
    "A МН ВИН НЕОД"                         => "AAIP4----1A----",
    "A МН ВИН ОД"                           => "AAXP4----1A----",
    "A МН ДАТ"                              => "AAXP3----1A----",
    "A МН ИМ"                               => "AAXP1----1A----",
    "A МН ПР"                               => "AAXP6----1A----",
    "A МН РОД"                              => "AAXP2----1A----",
    "A МН ТВОР"                             => "AAXP7----1A----",
    "A ПРЕВ ЕД ЖЕН ИМ"                      => "AAFS1----3A----",
    "A ПРЕВ ЕД ЖЕН РОД"                     => "AAFS2----3A----",
    "A ПРЕВ ЕД ЖЕН ТВОР"                    => "AAFS7----3A----",
    "A ПРЕВ ЕД МУЖ ИМ"                      => "AAMS1----3A----",
    "A ПРЕВ ЕД МУЖ ПР"                      => "AAMS6----3A----",
    "A ПРЕВ ЕД МУЖ РОД"                     => "AAMS2----3A----",
    "A ПРЕВ ЕД СРЕД ИМ"                     => "AANS1----3A----",
    "A ПРЕВ МН ВИН НЕОД"                    => "AAIP4----3A----",
    "A ПРЕВ МН ВИН ОД"                      => "AAXP4----3A----",
    "A ПРЕВ МН ДАТ"                         => "AAXP3----3A----",
    "A ПРЕВ МН ИМ"                          => "AAXP1----3A----",
    "A ПРЕВ МН ПР"                          => "AAXP6----3A----",
    "A ПРЕВ МН РОД"                         => "AAXP2----3A----",
    "A СЛ"                                  => "A2--------A----",
    "A СРАВ"                                => "AAXXX----2A----",
    "A СРАВ СМЯГ"                           => "AAXXX----2A---1",
    "ADV"                                   => "Db-------------",
    "ADV НЕСТАНД"                           => "Db------------1",
    "ADV СРАВ"                              => "Dg-------2A----",
    "ADV СРАВ СМЯГ"                         => "Dg-------2A---1",
    "COM"                                   => "A2--------A----",
    "COM СЛ"                                => "A2--------A----",
    "CONJ"                                  => "J^-------------",
    "INTJ"                                  => "II-------------",
    "NID"                                   => "XX-------------",
    "NUM"                                   => "C=-------------",
    "NUM ВИН"                               => "ClXX4----------",
    "NUM ВИН НЕОД"                          => "ClIX4----------",
    "NUM ВИН ОД"                            => "ClMX4----------",
    "NUM ДАТ"                               => "ClXX3----------",
    "NUM ЕД ЖЕН ВИН"                        => "ClFS4----------",
    "NUM ЕД ЖЕН ДАТ"                        => "ClFS3----------",
    "NUM ЕД ЖЕН ИМ"                         => "ClFS1----------",
    "NUM ЕД ЖЕН ПР"                         => "ClFS6----------",
    "NUM ЕД ЖЕН РОД"                        => "ClFS2----------",
    "NUM ЕД ЖЕН ТВОР"                       => "ClFS7----------",
    "NUM ЕД МУЖ ВИН НЕОД"                   => "ClIS4----------",
    "NUM ЕД МУЖ ВИН ОД"                     => "ClMS4----------",
    "NUM ЕД МУЖ ДАТ"                        => "ClMS3----------",
    "NUM ЕД МУЖ ИМ"                         => "ClMS1----------",
    "NUM ЕД МУЖ ПР"                         => "ClMS6----------",
    "NUM ЕД МУЖ РОД"                        => "ClMS2----------",
    "NUM ЕД МУЖ ТВОР"                       => "ClMS7----------",
    "NUM ЕД СРЕД ВИН"                       => "ClNS4----------",
    "NUM ЕД СРЕД ИМ"                        => "ClNS1----------",
    "NUM ЕД СРЕД ПР"                        => "ClNS6----------",
    "NUM ЕД СРЕД РОД"                       => "ClNS2----------",
    "NUM ЕД СРЕД ТВОР"                      => "ClNS7----------",
    "NUM ЖЕН ВИН НЕОД"                      => "ClFP4----------",
    "NUM ЖЕН ДАТ"                           => "ClFP3----------",
    "NUM ЖЕН ИМ"                            => "ClFP1----------",
    "NUM ЖЕН РОД"                           => "ClFP2----------",
    "NUM ИМ"                                => "ClXP1----------",
    "NUM МУЖ ВИН НЕОД"                      => "ClIP4----------",
    "NUM МУЖ ВИН ОД"                        => "ClMP4----------",
    "NUM МУЖ ДАТ"                           => "ClMP3----------",
    "NUM МУЖ ИМ"                            => "ClMP1----------",
    "NUM ПР"                                => "ClXP6----------",
    "NUM РОД"                               => "ClXP2----------",
    "NUM СЛ"                                => "Co-------------",
    "NUM СРЕД ВИН"                          => "ClNP4----------",
    "NUM СРЕД ИМ"                           => "ClNP1----------",
    "NUM ТВОР"                              => "ClNP7----------",
    "P"                                     => "TT-------------",
    "PART"                                  => "TT-------------",
    "PART НЕПРАВ"                           => "TT------------1",
    "PR"                                    => "RR--X----------",
    "S ЕД ЖЕН ВИН"                          => "NNFS4-----A----",
    "S ЕД ЖЕН ВИН НЕОД"                     => "NNFS4-----A----",
    "S ЕД ЖЕН ВИН ОД"                       => "NNFS4-----A----",
    "S ЕД ЖЕН ДАТ"                          => "NNFS3-----A----",
    "S ЕД ЖЕН ДАТ НЕОД"                     => "NNFS3-----A----",
    "S ЕД ЖЕН ДАТ ОД"                       => "NNFS3-----A----",
    "S ЕД ЖЕН ИМ"                           => "NNFS1-----A----",
    "S ЕД ЖЕН ИМ НЕОД"                      => "NNFS1-----A----",
    "S ЕД ЖЕН ИМ ОД"                        => "NNFS1-----A----",
    "S ЕД ЖЕН МЕСТН НЕОД"                   => "NNFS6-----A----",
    "S ЕД ЖЕН ПР"                           => "NNFS6-----A----",
    "S ЕД ЖЕН ПР НЕОД"                      => "NNFS6-----A----",
    "S ЕД ЖЕН ПР ОД"                        => "NNFS6-----A----",
    "S ЕД ЖЕН РОД"                          => "NNFS2-----A----",
    "S ЕД ЖЕН РОД НЕОД"                     => "NNFS2-----A----",
    "S ЕД ЖЕН РОД НЕОД НЕСТАНД"             => "NNFS2-----A---1",
    "S ЕД ЖЕН РОД ОД"                       => "NNFS2-----A----",
    "S ЕД ЖЕН РОД ОД НЕСТАНД"               => "NNFS2-----A---1",
    "S ЕД ЖЕН ТВОР НЕОД"                    => "NNFS7-----A----",
    "S ЕД ЖЕН ТВОР ОД"                      => "NNFS7-----A----",
    "S ЕД МУЖ ВИН НЕОД"                     => "NNIS4-----A----",
    "S ЕД МУЖ ВИН ОД"                       => "NNMS4-----A----",
    "S ЕД МУЖ ДАТ"                          => "NNMS3-----A----",
    "S ЕД МУЖ ДАТ НЕОД"                     => "NNIS3-----A----",
    "S ЕД МУЖ ДАТ ОД"                       => "NNMS3-----A----",
    "S ЕД МУЖ ДАТ ОД НЕСТАНД"               => "NNMS3-----A---1",
    "S ЕД МУЖ ЗВ ОД"                        => "NNMSX-----A----",
    "S ЕД МУЖ ИМ"                           => "NNMS1-----A----",
    "S ЕД МУЖ ИМ НЕОД"                      => "NNIS1-----A----",
    "S ЕД МУЖ ИМ ОД"                        => "NNMS1-----A----",
    "S ЕД МУЖ ИМ ОД НЕСТАНД"                => "NNMS1-----A---1",
    "S ЕД МУЖ МЕСТН НЕОД"                   => "NNIS6-----A----",
    "S ЕД МУЖ НЕОД"                         => "NNISX-----A----",
    "S ЕД МУЖ ПАРТ НЕОД"                    => "NNIS2-----A----",
    "S ЕД МУЖ ПР"                           => "NNMS6-----A----",
    "S ЕД МУЖ ПР НЕОД"                      => "NNIS6-----A----",
    "S ЕД МУЖ ПР ОД"                        => "NNMS6-----A----",
    "S ЕД МУЖ РОД"                          => "NNMS2-----A----",
    "S ЕД МУЖ РОД НЕОД"                     => "NNIS2-----A----",
    "S ЕД МУЖ РОД ОД"                       => "NNMS2-----A----",
    "S ЕД МУЖ ТВОР"                         => "NNMS7-----A----",
    "S ЕД МУЖ ТВОР НЕОД"                    => "NNIS7-----A----",
    "S ЕД МУЖ ТВОР ОД"                      => "NNMS7-----A----",
    "S ЕД МУЖ ТВОР ОД НЕСТАНД"              => "NNMS7-----A---1",
    "S ЕД СРЕД ВИН"                         => "NNNS4-----A----",
    "S ЕД СРЕД ВИН НЕОД"                    => "NNNS4-----A----",
    "S ЕД СРЕД ВИН ОД"                      => "NNNS4-----A----",
    "S ЕД СРЕД ДАТ"                         => "NNNS3-----A----",
    "S ЕД СРЕД ДАТ НЕОД"                    => "NNNS3-----A----",
    "S ЕД СРЕД ИМ"                          => "NNNS1-----A----",
    "S ЕД СРЕД ИМ НЕОД"                     => "NNNS1-----A----",
    "S ЕД СРЕД ИМ ОД"                       => "NNNS1-----A----",
    "S ЕД СРЕД НЕОД"                        => "NNNSX-----A----",
    "S ЕД СРЕД ПР"                          => "NNNS6-----A----",
    "S ЕД СРЕД ПР НЕОД"                     => "NNNS6-----A----",
    "S ЕД СРЕД РОД"                         => "NNNS2-----A----",
    "S ЕД СРЕД РОД НЕОД"                    => "NNNS2-----A----",
    "S ЕД СРЕД РОД ОД"                      => "NNNS2-----A----",
    "S ЕД СРЕД ТВОР НЕОД"                   => "NNNS7-----A----",
    "S ЕД СРЕД ТВОР ОД"                     => "NNNS7-----A----",
    "S ЖЕН НЕОД СЛ"                         => "A2--------A----",
    "S МН ВИН НЕОД"                         => "NNXP4-----A----",
    "S МН ВИН ОД"                           => "NNXP4-----A----",
    "S МН ДАТ"                              => "NNXP3-----A----",
    "S МН ДАТ НЕОД"                         => "NNXP3-----A----",
    "S МН ДАТ ОД"                           => "NNXP3-----A----",
    "S МН ЖЕН ВИН НЕОД"                     => "NNFP4-----A----",
    "S МН ЖЕН ВИН ОД"                       => "NNFP4-----A----",
    "S МН ЖЕН ДАТ НЕОД"                     => "NNFP3-----A----",
    "S МН ЖЕН ДАТ ОД"                       => "NNFP3-----A----",
    "S МН ЖЕН ИМ НЕОД"                      => "NNFP1-----A----",
    "S МН ЖЕН ИМ ОД"                        => "NNFP1-----A----",
    "S МН ЖЕН НЕОД"                         => "NNFPX-----A----",
    "S МН ЖЕН ПР НЕОД"                      => "NNFP6-----A----",
    "S МН ЖЕН РОД НЕОД"                     => "NNFP2-----A----",
    "S МН ЖЕН РОД ОД"                       => "NNFP2-----A----",
    "S МН ЖЕН ТВОР НЕОД"                    => "NNFP7-----A----",
    "S МН ЖЕН ТВОР ОД"                      => "NNFP7-----A----",
    "S МН ИМ"                               => "NNXP1-----A----",
    "S МН ИМ НЕОД"                          => "NNXP1-----A----",
    "S МН ИМ ОД"                            => "NNXP1-----A----",
    "S МН МУЖ ВИН НЕОД"                     => "NNIP4-----A----",
    "S МН МУЖ ВИН ОД"                       => "NNMP4-----A----",
    "S МН МУЖ ДАТ НЕОД"                     => "NNIP3-----A----",
    "S МН МУЖ ДАТ ОД"                       => "NNMP3-----A----",
    "S МН МУЖ ИМ НЕОД"                      => "NNIP1-----A----",
    "S МН МУЖ ИМ ОД"                        => "NNMP1-----A----",
    "S МН МУЖ ИМ ОД НЕСТАНД"                => "NNMP1-----A---1",
    "S МН МУЖ ПР НЕОД"                      => "NNIP6-----A----",
    "S МН МУЖ ПР ОД"                        => "NNMP6-----A----",
    "S МН МУЖ РОД НЕОД"                     => "NNIP2-----A----",
    "S МН МУЖ РОД НЕОД НЕСТАНД"             => "NNIP2-----A---1",
    "S МН МУЖ РОД ОД"                       => "NNMP2-----A----",
    "S МН МУЖ РОД ОД НЕСТАНД"               => "NNMP2-----A---1",
    "S МН МУЖ ТВОР НЕОД"                    => "NNIP7-----A----",
    "S МН МУЖ ТВОР ОД"                      => "NNMP7-----A----",
    "S МН ПР"                               => "NNXP6-----A----",
    "S МН ПР НЕОД"                          => "NNXP6-----A----",
    "S МН ПР ОД"                            => "NNXP6-----A----",
    "S МН РОД"                              => "NNXP2-----A----",
    "S МН РОД НЕОД"                         => "NNXP2-----A----",
    "S МН РОД ОД"                           => "NNXP2-----A----",
    "S МН СРЕД ВИН НЕОД"                    => "NNNP4-----A----",
    "S МН СРЕД ВИН ОД"                      => "NNNP4-----A----",
    "S МН СРЕД ДАТ НЕОД"                    => "NNNP3-----A----",
    "S МН СРЕД ДАТ ОД"                      => "NNNP3-----A----",
    "S МН СРЕД ИМ НЕОД"                     => "NNNP1-----A----",
    "S МН СРЕД ИМ ОД"                       => "NNNP1-----A----",
    "S МН СРЕД НЕОД"                        => "NNNPX-----A----",
    "S МН СРЕД ПР НЕОД"                     => "NNNP6-----A----",
    "S МН СРЕД ПР ОД"                       => "NNNP6-----A----",
    "S МН СРЕД РОД НЕОД"                    => "NNNP2-----A----",
    "S МН СРЕД РОД ОД"                      => "NNNP2-----A----",
    "S МН СРЕД ТВОР НЕОД"                   => "NNNP7-----A----",
    "S МН СРЕД ТВОР ОД"                     => "NNNP7-----A----",
    "S МН ТВОР"                             => "NNXP7-----A----",
    "S МН ТВОР НЕОД"                        => "NNXP7-----A----",
    "S МН ТВОР ОД"                          => "NNXP7-----A----",
    "S МУЖ НЕОД СЛ"                         => "A2--------A----",
    "S МУЖ ОД СЛ"                           => "A2--------A----",
    "S СРЕД НЕОД СЛ"                        => "A2--------A----",
    "V НЕСОВ ДЕЕПР НЕПРОШ"                  => "Ve--------A----",
    "V НЕСОВ ДЕЕПР ПРОШ"                    => "Vm--------A----",
    "V НЕСОВ ИЗЪЯВ НАСТ ЕД 2-Л"             => "VB-S---2P-AA---",
    "V НЕСОВ ИЗЪЯВ НАСТ ЕД 3-Л"             => "VB-S---3P-AA---",
    "V НЕСОВ ИЗЪЯВ НАСТ МН 3-Л"             => "VB-P---3P-AA---",
    "V НЕСОВ ИЗЪЯВ НЕПРОШ ЕД 1-Л"           => "VB-S---1P-AA---",
    "V НЕСОВ ИЗЪЯВ НЕПРОШ ЕД 2-Л"           => "VB-S---2P-AA---",
    "V НЕСОВ ИЗЪЯВ НЕПРОШ ЕД 3-Л"           => "VB-S---3P-AA---",
    "V НЕСОВ ИЗЪЯВ НЕПРОШ ЕД 3-Л НЕСТАНД"   => "VB-S---3P-AA--1",
    "V НЕСОВ ИЗЪЯВ НЕПРОШ МН 1-Л"           => "VB-P---1P-AA---",
    "V НЕСОВ ИЗЪЯВ НЕПРОШ МН 2-Л"           => "VB-P---2P-AA---",
    "V НЕСОВ ИЗЪЯВ НЕПРОШ МН 3-Л"           => "VB-P---3P-AA---",
    "V НЕСОВ ИЗЪЯВ НЕПРОШ МН 3-Л НЕСТАНД"   => "VB-P---3P-AA--1",
    "V НЕСОВ ИЗЪЯВ ПРОШ ЕД ЖЕН"             => "VpFS---XR-AA---",
    "V НЕСОВ ИЗЪЯВ ПРОШ ЕД МУЖ"             => "VpMS---XR-AA---",
    "V НЕСОВ ИЗЪЯВ ПРОШ ЕД СРЕД"            => "VpNS---XR-AA---",
    "V НЕСОВ ИЗЪЯВ ПРОШ МН"                 => "VpXP---XR-AA---",
    "V НЕСОВ ИНФ"                           => "Vf--------A----",
    "V НЕСОВ ПОВ ЕД 2-Л"                    => "Vi-S---2--A----",
    "V НЕСОВ ПОВ МН 2-Л"                    => "Vi-P---2--A----",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД ЖЕН ВИН"        => "VsFS4--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД ЖЕН ИМ"         => "VsFS1--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД ЖЕН ПР"         => "VsFS6--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД ЖЕН РОД"        => "VsFS2--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД ЖЕН ТВОР"       => "VsFS7--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД МУЖ ВИН НЕОД"   => "VsIS4--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД МУЖ ВИН ОД"     => "VsMS4--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД МУЖ ДАТ"        => "VsMS3--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД МУЖ ИМ"         => "VsMS1--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД МУЖ ПР"         => "VsMS6--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД МУЖ РОД"        => "VsMS2--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД МУЖ ТВОР"       => "VsMS7--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД СРЕД ВИН"       => "VsNS4--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД СРЕД ИМ"        => "VsNS1--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД СРЕД ПР"        => "VsNS6--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД СРЕД РОД"       => "VsNS2--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ ЕД СРЕД ТВОР"      => "VsNS7--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ МН ВИН НЕОД"       => "VsXP4--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ МН ВИН ОД"         => "VsXP4--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ МН ДАТ"            => "VsXP3--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ МН ИМ"             => "VsXP1--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ МН ПР"             => "VsXP6--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ МН РОД"            => "VsXP2--XX-AP---",
    "V НЕСОВ ПРИЧ НЕПРОШ МН ТВОР"           => "VsXP7--XX-AP---",
    "V НЕСОВ ПРИЧ ПРОШ ЕД ЖЕН ДАТ"          => "VsFS3--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ ЕД ЖЕН ИМ"           => "VsFS1--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ ЕД ЖЕН ПР"           => "VsFS6--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ ЕД ЖЕН ТВОР"         => "VsFS7--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ ЕД МУЖ ВИН НЕОД"     => "VsIS4--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ ЕД МУЖ ИМ"           => "VsMS1--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ ЕД МУЖ РОД"          => "VsMS2--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ ЕД МУЖ ТВОР"         => "VsMS7--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ ЕД СРЕД ВИН"         => "VsNS4--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ МН ВИН НЕОД"         => "VsXP4--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ МН ВИН ОД"           => "VsXP4--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ МН ДАТ"              => "VsXP3--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ МН ИМ"               => "VsXP1--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ МН РОД"              => "VsXP2--XR-AP---",
    "V НЕСОВ ПРИЧ ПРОШ МН ТВОР"             => "VsXP7--XR-AP---",
    "V НЕСОВ СТРАД ИЗЪЯВ НЕПРОШ ЕД 3-Л"     => "VB-S---3P-AA---",
    "V НЕСОВ СТРАД ИЗЪЯВ НЕПРОШ МН 3-Л"     => "VB-P---3P-AA---",
    "V НЕСОВ СТРАД ИЗЪЯВ ПРОШ ЕД ЖЕН"       => "VpFS---XR-AA---",
    "V НЕСОВ СТРАД ИЗЪЯВ ПРОШ ЕД МУЖ"       => "VpMS---XR-AA---",
    "V НЕСОВ СТРАД ИЗЪЯВ ПРОШ ЕД СРЕД"      => "VpNS---XR-AA---",
    "V НЕСОВ СТРАД ИЗЪЯВ ПРОШ МН"           => "VpXP---XR-AA---",
    "V НЕСОВ СТРАД ИНФ"                     => "Vf--------A----",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ ЕД ЖЕН ИМ"   => "VsFS1--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ ЕД ЖЕН РОД"  => "VsFS2--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ ЕД ЖЕН ТВОР" => "VsFS7--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ ЕД МУЖ ИМ"   => "VsMS1--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ ЕД МУЖ РОД"  => "VsMS2--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ ЕД МУЖ ТВОР" => "VsMS7--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ ЕД СРЕД ВИН" => "VsNS4--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ ЕД СРЕД ИМ"  => "VsNS1--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ ЕД СРЕД РОД" => "VsNS2--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ МН ВИН НЕОД" => "VsXP4--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ МН ИМ"       => "VsXP1--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ НЕПРОШ МН РОД"      => "VsXP2--XX-AP---",
    "V НЕСОВ СТРАД ПРИЧ ПРОШ ЕД ЖЕН ВИН"    => "VsFS4--XR-AP---",
    "V НЕСОВ СТРАД ПРИЧ ПРОШ ЕД МУЖ ВИН ОД" => "VsMS4--XR-AP---",
    "V НЕСОВ СТРАД ПРИЧ ПРОШ ЕД СРЕД ВИН"   => "VsNS4--XR-AP---",
    "V НЕСОВ СТРАД ПРИЧ ПРОШ ЕД СРЕД ИМ"    => "VsNS1--XR-AP---",
    "V НЕСОВ СТРАД ПРИЧ ПРОШ КР ЕД ЖЕН"     => "VsFSX--XR-AP--1",
    "V НЕСОВ СТРАД ПРИЧ ПРОШ КР ЕД СРЕД"    => "VsNSX--XR-AP--1",
    "V НЕСОВ СТРАД ПРИЧ ПРОШ КР МН"         => "VsXPX--XR-AP--1",
    "V НЕСОВ СТРАД ПРИЧ ПРОШ МН ИМ"         => "VsXP1--XR-AP---",
    "V СОВ ДЕЕПР НЕПРОШ"                    => "Ve--------A----",
    "V СОВ ДЕЕПР ПРОШ"                      => "Vm--------A----",
    "V СОВ ДЕЕПР ПРОШ НЕПРАВ"               => "Vm--------A---1",
    "V СОВ ИЗЪЯВ НЕПРОШ ЕД 1-Л"             => "VB-S---1F-AA---",
    "V СОВ ИЗЪЯВ НЕПРОШ ЕД 1-Л НЕСТАНД"     => "VB-S---1F-AA--1",
    "V СОВ ИЗЪЯВ НЕПРОШ ЕД 2-Л"             => "VB-S---2F-AA---",
    "V СОВ ИЗЪЯВ НЕПРОШ ЕД 3-Л"             => "VB-S---3F-AA---",
    "V СОВ ИЗЪЯВ НЕПРОШ МН 1-Л"             => "VB-P---1F-AA---",
    "V СОВ ИЗЪЯВ НЕПРОШ МН 2-Л"             => "VB-P---2F-AA---",
    "V СОВ ИЗЪЯВ НЕПРОШ МН 3-Л"             => "VB-P---3F-AA---",
    "V СОВ ИЗЪЯВ ПРОШ ЕД ЖЕН"               => "VpFS---XR-AA---",
    "V СОВ ИЗЪЯВ ПРОШ ЕД МУЖ"               => "VpMS---XR-AA---",
    "V СОВ ИЗЪЯВ ПРОШ ЕД СРЕД"              => "VpNS---XR-AA---",
    "V СОВ ИЗЪЯВ ПРОШ МН"                   => "VpXP---XR-AA---",
    "V СОВ ИНФ"                             => "Vf--------A----",
    "V СОВ ПОВ ЕД 2-Л"                      => "Vi-S---2--A----",
    "V СОВ ПОВ ЕД 2-Л НЕСТАНД"              => "Vi-S---2--A---1",
    "V СОВ ПОВ МН 1-Л"                      => "Vi-P---1--A----",
    "V СОВ ПОВ МН 2-Л"                      => "Vi-P---2--A----",
    "V СОВ ПРИЧ ПРОШ ЕД ЖЕН ВИН"            => "VsFS4--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД ЖЕН ДАТ"            => "VsFS3--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД ЖЕН ИМ"             => "VsFS1--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД ЖЕН ПР"             => "VsFS6--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД ЖЕН ТВОР"           => "VsFS7--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД МУЖ ВИН НЕОД"       => "VsIS4--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД МУЖ ВИН ОД"         => "VsMS4--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД МУЖ ДАТ"            => "VsMS3--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД МУЖ ИМ"             => "VsMS1--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД МУЖ ПР"             => "VsMS6--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД МУЖ РОД"            => "VsMS2--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД МУЖ ТВОР"           => "VsMS7--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД СРЕД ВИН"           => "VsNS4--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД СРЕД ИМ"            => "VsNS1--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД СРЕД ПР"            => "VsNS6--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД СРЕД РОД"           => "VsNS2--XR-AP---",
    "V СОВ ПРИЧ ПРОШ ЕД СРЕД ТВОР"          => "VsNS7--XR-AP---",
    "V СОВ ПРИЧ ПРОШ МН ВИН НЕОД"           => "VsXP4--XR-AP---",
    "V СОВ ПРИЧ ПРОШ МН ВИН ОД"             => "VsXP4--XR-AP---",
    "V СОВ ПРИЧ ПРОШ МН ИМ"                 => "VsXP1--XR-AP---",
    "V СОВ ПРИЧ ПРОШ МН ПР"                 => "VsXP6--XR-AP---",
    "V СОВ ПРИЧ ПРОШ МН РОД"                => "VsXP2--XR-AP---",
    "V СОВ ПРИЧ ПРОШ МН ТВОР"               => "VsXP7--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД ЖЕН ВИН"      => "VsFS4--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД ЖЕН ДАТ"      => "VsFS3--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД ЖЕН ИМ"       => "VsFS1--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД ЖЕН ПР"       => "VsFS6--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД ЖЕН РОД"      => "VsFS2--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД ЖЕН ТВОР"     => "VsFS7--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД МУЖ ВИН НЕОД" => "VsIS4--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД МУЖ ДАТ"      => "VsMS3--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД МУЖ ИМ"       => "VsMS1--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД МУЖ ПР"       => "VsMS6--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД МУЖ РОД"      => "VsMS2--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД МУЖ ТВОР"     => "VsMS7--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД СРЕД ВИН"     => "VsNS4--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД СРЕД ИМ"      => "VsNS1--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД СРЕД ПР"      => "VsNS6--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД СРЕД РОД"     => "VsNS2--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ ЕД СРЕД ТВОР"    => "VsNS7--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ КР ЕД ЖЕН"       => "VsFSX--XR-AP--1",
    "V СОВ СТРАД ПРИЧ ПРОШ КР ЕД МУЖ"       => "VsMSX--XR-AP--1",
    "V СОВ СТРАД ПРИЧ ПРОШ КР ЕД СРЕД"      => "VsNSX--XR-AP--1",
    "V СОВ СТРАД ПРИЧ ПРОШ КР МН"           => "VsXPX--XR-AP--1",
    "V СОВ СТРАД ПРИЧ ПРОШ МН ВИН НЕОД"     => "VsXP4--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ МН ВИН ОД"       => "VsXP4--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ МН ДАТ"          => "VsXP3--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ МН ИМ"           => "VsXP1--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ МН ПР"           => "VsXP6--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ МН РОД"          => "VsXP2--XR-AP---",
    "V СОВ СТРАД ПРИЧ ПРОШ МН ТВОР"         => "VsXP7--XR-AP---",
    "Z:"                                    => "Z:-------------"
);



while(<>)
{
    if(m/<t>([^<]*)/)
    {
        my $ptag = $conv{$1};
        s/<t>([^<]*)/<t>$ptag/;
    }
    print;
}
